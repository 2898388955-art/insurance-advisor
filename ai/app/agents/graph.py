"""LangGraph 编排：意图路由 → 检索/推荐/对比 → 生成。

生成阶段拆成 prepare / stream 两步：
- prepare 完成路由与数据准备，产出 LLM 消息
- stream 直接消费 LLM 的 token 流，供 SSE 真流式输出
非流式接口复用同一份 prepare + complete，避免两套逻辑。
"""
from __future__ import annotations

import logging
import re
from typing import AsyncIterator, TypedDict

from langgraph.graph import END, START, StateGraph

from app.agents.prompts import (ADVISOR_SYSTEM, COMPARE_SYSTEM, RAG_SYSTEM,
                                advisor_user_prompt, compare_user_prompt, rag_user_prompt)
from app.llm.client import ChatClient, LlmError
from app.services.compliance_service import ComplianceService
from app.services.product_service import ProductService, ProductServiceError
from app.services.retrieval_service import RetrievalService, build_context

logger = logging.getLogger(__name__)

AGE_RE = re.compile(r"(\d{1,2})\s*岁")

# 职业 → 推荐险种（分类 ID 对应 category 表）
OCCUPATION_RULES: list[tuple[tuple[str, ...], str, list[int]]] = [
    (("程序员", "教师", "会计", "文员", "设计师", "办公室", "公务员", "工程师"),
     "低风险室内职业", [2, 3]),          # 医疗险 + 重疾险
    (("销售", "自由职业", "个体", "创业"), "中风险外勤职业", [2, 1]),  # 医疗 + 意外
    (("司机", "外卖", "快递", "建筑", "高空", "消防", "矿工", "工人", "施工"),
     "高风险体力/外勤职业", [1, 41]),     # 综合/交通意外 + 定期寿险
    (("医生", "护士"), "医疗从业者", [2, 3]),
]


class AgentState(TypedDict, total=False):
    question: str
    history: list[dict]
    product_id: int | None
    conversation_id: int | None
    intent: str
    occupation: str | None
    categories: list[int]
    hits: list[dict]
    products: list[dict]
    compare: dict | None
    citations: list[dict]
    tools: list[dict]
    llm_messages: list[dict]
    answer_fixed: str
    answer: str


class InsuranceAgent:
    def __init__(self) -> None:
        self.llm = ChatClient()
        self.retrieval = RetrievalService()
        self.products = ProductService()
        self.compliance = ComplianceService()
        self.graph = self._build()

    # ---------- 路由与职业 ----------
    @staticmethod
    def route(question: str) -> str:
        q = question.strip()
        if any(k in q for k in ("对比", "比较", "哪个好", "区别", "差异")):
            return "compare"
        if any(k in q for k in ("推荐", "适合", "买什么", "怎么选", "预算",
                                "想买", "买一份", "配置", "投保")):
            return "advisor"
        if any(k in q for k in ("你好", "谢谢", "在吗")):
            return "chitchat"
        return "rag"

    @staticmethod
    def detect_occupation(question: str) -> tuple[str | None, list[int]]:
        for keywords, label, categories in OCCUPATION_RULES:
            if any(k in question for k in keywords):
                return label, categories
        return None, []

    # ---------- 图 ----------
    def _build(self):
        g = StateGraph(AgentState)

        async def router_node(state: AgentState) -> dict:
            occupation, categories = self.detect_occupation(state["question"])
            return {"intent": self.route(state["question"]),
                    "occupation": occupation,
                    "categories": categories,
                    "tools": []}

        async def retrieve_node(state: AgentState) -> dict:
            hits = await self.retrieval.retrieve(
                state["question"], product_id=state.get("product_id"))
            return {"hits": hits,
                    "citations": self._citations(hits),
                    "tools": [{"name": "clause_search",
                               "detail": f"检索条款 {len(hits)} 条"}]}

        async def rag_prepare(state: AgentState) -> dict:
            hits = state.get("hits", [])
            if not hits:
                return {"answer_fixed": "条款中未找到相关约定。可以换个说法，或在产品详情页查看条款原文。"}
            return {"llm_messages": self._messages(
                RAG_SYSTEM, rag_user_prompt(state["question"], build_context(hits)),
                state.get("history"))}

        async def advisor_prepare(state: AgentState) -> dict:
            age = self._extract_age(state["question"])
            categories = self._categories_of(state)
            try:
                products = await self._search_products(age, categories)
            except ProductServiceError as e:
                logger.warning("product service failed: %s", e)
                return {"answer_fixed": "产品服务暂不可用，请稍后再试。", "products": []}
            if not products:
                return {"answer_fixed": "没有找到符合条件的产品，可以放宽年龄或职业限制再试。",
                        "products": []}
            occupation = state.get("occupation")
            hint = f"（用户职业：{occupation}，优先考虑对应险种）" if occupation else ""
            return {"products": products,
                    "product_id": products[0]["id"],
                    "tools": [{"name": "product_search",
                               "detail": f"筛选产品 {len(products)} 个"}],
                    "llm_messages": self._messages(
                ADVISOR_SYSTEM,
                advisor_user_prompt(state["question"] + hint, self._format_products(products)),
                state.get("history"))}

        async def compare_prepare(state: AgentState) -> dict:
            try:
                ids = await self._compare_ids(state.get("product_id"))
                if len(ids) < 2:
                    return {"answer_fixed": "请先在产品页选择 2~4 个产品加入对比，再问我差异。"}
                data = await self.products.compare(ids)
            except ProductServiceError as e:
                logger.warning("compare failed: %s", e)
                return {"answer_fixed": "对比服务暂不可用，请稍后再试。"}
            rows = "\n".join(
                f"{r['label']}：" + " | ".join(r["values"]) for r in data.get("rows", []))
            return {"compare": data,
                    "tools": [{"name": "compare",
                               "detail": f"对比产品 {len(ids)} 个"}],
                    "llm_messages": self._messages(
                COMPARE_SYSTEM, compare_user_prompt(state["question"], rows),
                state.get("history"))}

        async def chitchat_node(state: AgentState) -> dict:
            return {"answer_fixed": "你好，我是保顾问。可以问我条款细节、产品推荐或产品差异。"}

        g.add_node("router", router_node)
        g.add_node("retrieve", retrieve_node)
        g.add_node("rag_prepare", rag_prepare)
        g.add_node("advisor", advisor_prepare)
        g.add_node("compare", compare_prepare)
        g.add_node("chitchat", chitchat_node)

        g.add_edge(START, "router")
        g.add_conditional_edges("router", lambda s: s["intent"], {
            "rag": "retrieve", "advisor": "advisor",
            "compare": "compare", "chitchat": "chitchat",
        })
        g.add_edge("retrieve", "rag_prepare")
        for node in ("rag_prepare", "advisor", "compare", "chitchat"):
            g.add_edge(node, END)
        return g.compile()

    # ---------- 对外 ----------
    async def prepare(self, question: str, history: list[dict] | None = None,
                      product_id: int | None = None,
                      conversation_id: int | None = None) -> AgentState:
        return await self.graph.ainvoke({
            "question": question,
            "history": history or [],
            "product_id": product_id,
            "conversation_id": conversation_id,
        })

    async def run(self, question: str, history: list[dict] | None = None,
                  product_id: int | None = None,
                  conversation_id: int | None = None) -> AgentState:
        state = await self.prepare(question, history, product_id, conversation_id)
        if state.get("answer_fixed"):
            answer = state["answer_fixed"]
        else:
            try:
                answer = await self.llm.complete(state["llm_messages"])
            except LlmError as e:
                logger.warning("llm failed: %s", e)
                answer = self._fallback_answer(state)
        return self.finalize(state, answer)

    async def stream(self, question: str, history: list[dict] | None = None,
                     product_id: int | None = None,
                     conversation_id: int | None = None) -> AsyncIterator[tuple[str, object]]:
        """先产出 state，再逐 token 产出文本；调用方负责累积与合规。"""
        state = await self.prepare(question, history, product_id, conversation_id)
        yield "__state__", state
        if state.get("answer_fixed"):
            text = state["answer_fixed"]
            for i in range(0, len(text), 12):
                yield "token", text[i:i + 12]  # type: ignore[return-value]
            return
        try:
            async for token in self.llm.stream(state["llm_messages"]):
                yield "token", token  # type: ignore[return-value]
        except LlmError as e:
            logger.warning("llm stream failed: %s", e)
            for chunk in self._chunks(self._fallback_answer(state)):
                yield "token", chunk  # type: ignore[return-value]

    def finalize(self, state: AgentState, answer: str) -> AgentState:
        checked, warnings = self.compliance.check(answer)
        state["answer"] = checked
        if warnings:
            state["warnings"] = warnings  # type: ignore[typeddict-unknown-key]
        return state

    # ---------- 辅助 ----------
    @staticmethod
    def _extract_age(question: str) -> int | None:
        m = AGE_RE.search(question)
        return int(m.group(1)) if m else None

    @staticmethod
    def _categories_of(state: AgentState) -> list[int]:
        raw = state.get("categories")
        if isinstance(raw, list):
            return raw
        _, categories = InsuranceAgent.detect_occupation(state["question"])
        return categories

    async def _search_products(self, age: int | None, categories: list[int]) -> list[dict]:
        if not categories:
            return await self.products.search(age=age, size=5)
        merged: list[dict] = []
        seen: set[int] = set()
        for cid in categories:
            for p in await self.products.search(age=age, category_id=cid, size=3):
                if p["id"] not in seen:
                    seen.add(p["id"])
                    merged.append(p)
        return merged[:6]

    @staticmethod
    def _messages(system: str, user: str, history: list[dict] | None) -> list[dict]:
        msgs = [{"role": "system", "content": system}]
        for m in (history or [])[-6:]:
            if m.get("content"):
                msgs.append({"role": m.get("role", "user"), "content": m["content"][:1500]})
        msgs.append({"role": "user", "content": user})
        return msgs

    @staticmethod
    def _format_products(products: list[dict]) -> str:
        lines = []
        for p in products:
            renewal = p.get("guaranteedRenewal")
            renewal_text = ("保证续保" if renewal is True
                            else "不保证续保" if renewal is False else "条款未提及")
            lines.append(
                f"- {p['name']}｜{p['company']}｜年龄 {p.get('minAge')}-{p.get('maxAge')} 岁"
                f"｜等待期 {p.get('waitingDays')} 天｜续保 {renewal_text}"
                f"｜价格 {p.get('priceDisplay')}")
        return "\n".join(lines)

    async def _compare_ids(self, product_id: int | None) -> list[int]:
        if product_id:
            detail = await self.products.detail(product_id)
            same = await self.products.search(category_id=detail.get("categoryId"), size=3)
            return [product_id] + [p["id"] for p in same if p["id"] != product_id][:1]
        same = await self.products.search(size=2)
        return [p["id"] for p in same]

    def _fallback_answer(self, state: AgentState) -> str:
        hits = state.get("hits", [])
        if hits:
            return "模型服务暂不可用。以下是检索到的条款原文：\n" + \
                   "\n".join(f"[{i}] {h['heading_path']}（第 {h['page_no']} 页）"
                             for i, h in enumerate(hits, 1))
        return "模型服务暂不可用，请稍后再试。"

    @staticmethod
    def _chunks(text: str, size: int = 12):
        for i in range(0, len(text), size):
            yield text[i:i + size]

    @staticmethod
    def _citations(hits: list[dict]) -> list[dict]:
        return [{
            "index": i,
            "chunk_id": h["chunk_id"],
            "parent_id": h["parent_id"],
            "product_id": h["product_id"],
            "heading_path": h["heading_path"],
            "page_no": h["page_no"],
            "snippet": h["text"][:120],
        } for i, h in enumerate(hits, 1)]
