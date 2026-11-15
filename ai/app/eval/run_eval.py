"""评测：纯向量 / BM25 / 多组加权 RRF 在同一数据集上的对比。

标准答案按「章节标题 + 关键词」判定，不依赖被测系统的召回结果。
产品内检索使用省略产品名的短问句；全局检索使用带产品名的完整问句。
"""
from __future__ import annotations

import asyncio
import json
import re
import time
from pathlib import Path

from pymilvus import MilvusClient

from app.agents.graph import InsuranceAgent
from app.config import settings
from app.rag.embedder import OllamaEmbedder
from app.rag.fusion import weighted_rrf
from app.rag.milvus_store import COLLECTION

ROOT = Path(__file__).resolve().parents[3]
QUESTIONS = ROOT / "data" / "eval" / "questions.jsonl"
RESULT_JSON = ROOT / "data" / "eval" / "results.json"
REPORT = ROOT / "docs" / "eval-report.md"

KS = (1, 3, 5, 10)
CANDIDATES = 20
FIELDS = ["heading_path", "text"]
CITATION_SAMPLE = 6

MODES: dict[str, tuple[str, tuple[float, float] | None]] = {
    "dense": ("纯向量", None),
    "sparse": ("BM25", None),
    "rrf_equal": ("RRF 等权 (0.5/0.5)", (0.5, 0.5)),
    "rrf_w70": ("RRF 加权 (0.7/0.3)", (0.7, 0.3)),
    "rrf_w80": ("RRF 加权 (0.8/0.2)", (0.8, 0.2)),
    "rrf_w90": ("RRF 加权 (0.9/0.1)", (0.9, 0.1)),
}


def load() -> list[dict]:
    return [json.loads(line) for line in QUESTIONS.open(encoding="utf-8")]


def relevant(item: dict, hit: dict) -> bool:
    section = item.get("expected_section") or ""
    keyword = item.get("expected_keyword") or ""
    entity = hit.get("entity", hit)
    if section and section in (entity.get("heading_path") or ""):
        return True
    for alt in keyword.split("|"):
        if alt and re.search(alt, entity.get("text") or ""):
            return True
    return False


class Retriever:
    def __init__(self) -> None:
        self.client = MilvusClient(uri=f"http://{settings.milvus_host}:{settings.milvus_port}")
        self.embedder = OllamaEmbedder()

    def embed(self, text: str) -> list[float]:
        return self.embedder.embed_one(text)

    def dense(self, vec: list[float], pid: int | None) -> list[dict]:
        expr = f"product_id == {pid}" if pid else ""
        res = self.client.search(
            COLLECTION, data=[vec], anns_field="embedding", limit=CANDIDATES,
            filter=expr, output_fields=FIELDS,
            search_params={"metric_type": "COSINE", "params": {"ef": 64}},
        )
        return [{"id": int(h["id"]), "entity": h["entity"]} for h in res[0]]

    def sparse(self, q: str, pid: int | None) -> list[dict]:
        expr = f"product_id == {pid}" if pid else ""
        res = self.client.search(
            COLLECTION, data=[q], anns_field="sparse", limit=CANDIDATES,
            filter=expr, output_fields=FIELDS,
            search_params={"metric_type": "BM25"},
        )
        return [{"id": int(h["id"]), "entity": h["entity"]} for h in res[0]]


def new_acc() -> dict:
    return {k: 0 for k in KS} | {"rr": 0.0, "n": 0}


def add(acc: dict, flags: list[bool]) -> None:
    for k in KS:
        if any(flags[:k]):
            acc[k] += 1
    first = next((i + 1 for i, ok in enumerate(flags) if ok), None)
    if first:
        acc["rr"] += 1.0 / first
    acc["n"] += 1


def finalize(acc: dict) -> dict:
    n = acc["n"]
    return {"n": n, **{f"recall@{k}": round(acc[k] / n, 3) if n else 0 for k in KS},
            "mrr": round(acc["rr"] / n, 3) if n else 0}


def evaluate_scope(items: list[dict], scope: str, retriever: Retriever) -> dict:
    qkey = "question" if scope == "filtered" else "question_global"
    accs = {m: new_acc() for m in MODES}

    for item in items:
        if not item.get("doc_id"):
            continue
        q = item.get(qkey) or item["question"]
        pid = item.get("product_id") if scope == "filtered" else None
        vec = retriever.embed(q)
        dense = retriever.dense(vec, pid)
        sparse = retriever.sparse(q, pid)

        rankings: dict[str, list[dict]] = {"dense": dense, "sparse": sparse}
        for mode, (_, weights) in MODES.items():
            if weights is None:
                continue
            rankings[mode] = weighted_rrf(
                dense, sparse, k=60, dense_weight=weights[0],
                sparse_weight=weights[1], limit=max(KS),
            )
        for mode, hits in rankings.items():
            add(accs[mode], [relevant(item, h) for h in hits])

    return {mode: finalize(acc) for mode, acc in accs.items()}


def router_eval(items: list[dict]) -> dict:
    cases = [x for x in items if x["intent"] != "rag"]
    ok = sum(1 for x in cases if InsuranceAgent.route(x["question"]) == x["intent"])
    return {"n": len(cases), "accuracy": round(ok / len(cases), 3) if cases else 0}


async def citation_eval(items: list[dict], agent: InsuranceAgent) -> dict:
    sample = [x for x in items if x.get("doc_id")][:CITATION_SAMPLE]
    hit = 0
    for item in sample:
        state = await agent.run(item["question"], product_id=item["product_id"])
        cites = state.get("citations") or []
        if any(item["expected_section"] in (c.get("heading_path") or "") for c in cites):
            hit += 1
    return {"n": len(sample), "hit": round(hit / len(sample), 3) if sample else 0}


def write_report(results: dict, router: dict, cites: dict, total: int) -> None:
    lines = [
        "# 评测报告",
        "",
        f"> 生成时间 {time.strftime('%Y-%m-%d %H:%M')}　｜　数据集 `data/eval/questions.jsonl`（{total} 条）",
        "",
        "## 实验设计",
        "",
        "- **产品内检索**：`product_id` 已知，问句省略产品名（如“等待期是多久？”）",
        "- **全局检索**：问句带完整产品名，模拟未指定产品时的检索",
        "- 相关性判定：命中结果所属章节标题包含期望章节，或正文命中期望关键词，即算相关",
        "- 两路各取 top20，应用层加权 RRF 融合：`score = Σ w_i / (k + rank_i)`，k=60",
        "",
        "## 检索指标",
        "",
    ]
    for scope, title in [("filtered", "产品内检索"), ("global", "全局检索")]:
        lines += [f"### {title}", "",
                  "| 检索方式 | Recall@1 | Recall@3 | Recall@5 | Recall@10 | MRR |",
                  "|---|---|---|---|---|---|"]
        for mode, (name, _) in MODES.items():
            m = results[scope][mode]
            lines.append(f"| {name} | {m['recall@1']} | {m['recall@3']} | {m['recall@5']} | "
                         f"{m['recall@10']} | {m['mrr']} |")
        lines.append("")

    f = results["filtered"]
    g = results["global"]
    best_f = max(MODES, key=lambda m: (f[m]["recall@5"], f[m]["mrr"]))
    best_g = max(MODES, key=lambda m: (g[m]["recall@5"], g[m]["mrr"]))
    lines += [
        "## 路由与引用",
        "",
        f"- 意图路由准确率：**{router['accuracy']}**（{router['n']} 条）",
        f"- 引用命中率：**{cites['hit']}**（抽样 {cites['n']} 条，引用章节包含期望章节即算命中）",
        "",
        "## 结论",
        "",
        f"- 产品内检索最优：**{MODES[best_f][0]}**，Recall@5={f[best_f]['recall@5']}，MRR={f[best_f]['mrr']}",
        f"- 全局检索最优：**{MODES[best_g][0]}**，Recall@5={g[best_g]['recall@5']}，MRR={g[best_g]['mrr']}",
        "- **项目默认采用纯向量检索**（`RETRIEVAL_SPARSE_WEIGHT=0`）；混合检索的代码与索引保留，"
        "当语料扩展到跨公司数百份条款后可通过权重重新启用。",
        "- 等权 RRF 在本语料上弱于纯向量：dense 排序本身很强，BM25 的噪声会稀释头部结果；"
        "加权 RRF 用于控制这一影响。",
        "- 引用命中率抽样仅 6 条，波动较大；完整答案评测需要 LLM-as-judge。",
        "",
        "## 复现",
        "",
        "```bash",
        "cd ai",
        "uv run python -m app.eval.build_dataset",
        "uv run python -m app.eval.run_eval",
        "```",
        "",
    ]
    REPORT.write_text("\n".join(lines), encoding="utf-8")


async def main() -> None:
    dataset = load()
    retriever = Retriever()
    results = {scope: evaluate_scope(dataset, scope, retriever)
               for scope in ("filtered", "global")}
    router = router_eval(dataset)
    cites = await citation_eval(dataset, InsuranceAgent())

    RESULT_JSON.write_text(json.dumps(
        {"results": results, "router": router, "citations": cites},
        ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(results, router, cites, len(dataset))
    print(json.dumps({"filtered": results["filtered"], "global": results["global"],
                      "router": router, "citations": cites}, ensure_ascii=False))


if __name__ == "__main__":
    asyncio.run(main())
