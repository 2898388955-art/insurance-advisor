"""对话接口：普通 JSON 与 SSE 真流式两种形态。"""
from __future__ import annotations

import asyncio
import json
import logging
import time
import uuid

from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse

from app.agents.graph import InsuranceAgent
from app.schemas.chat import ChatRequest, ChatResponse, Citation
from app.services.checkpoint_service import CheckpointService
from app.services.summary_service import SummaryService

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/v1", tags=["chat"])

_agent = InsuranceAgent()
_checkpoints = CheckpointService()
_summary = SummaryService(_checkpoints)


def _history(req: ChatRequest) -> list[dict]:
    """有会话 ID 时以服务端记忆为准（摘要 + 最近几轮）。"""
    if req.conversation_id:
        return _summary.history(req.conversation_id)
    return [m.model_dump() for m in req.history]


def _product_id(req: ChatRequest) -> int | None:
    """显式传入优先；否则用上一轮记住的产品，支持"它/这款"指代。"""
    if req.product_id:
        return req.product_id
    if req.conversation_id:
        return _checkpoints.latest_product_id(req.conversation_id)
    return None


def _save(req: ChatRequest, trace_id: str, state: dict) -> None:
    if not req.conversation_id:
        return
    try:
        _checkpoints.save(req.conversation_id, trace_id, state)
        asyncio.create_task(_summary.maybe_summarize(req.conversation_id))
    except Exception:
        logger.exception("save checkpoint failed conversation=%s", req.conversation_id)


@router.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest) -> ChatResponse:
    trace_id = uuid.uuid4().hex[:16]
    started = time.perf_counter()
    try:
        state = await _agent.run(
            req.message, history=_history(req),
            product_id=_product_id(req), conversation_id=req.conversation_id,
        )
    except Exception as e:
        logger.exception("chat failed trace=%s", trace_id)
        raise HTTPException(status_code=500, detail="对话服务内部错误") from e

    state["elapsed_ms"] = int((time.perf_counter() - started) * 1000)
    _save(req, trace_id, state)
    return ChatResponse(
        answer=state.get("answer", ""),
        intent=state.get("intent", "rag"),
        citations=[Citation(**c) for c in state.get("citations", [])],
        trace_id=trace_id,
        disclaimer="内容仅供参考，不构成投保建议。",
    )


@router.post("/chat/stream")
async def chat_stream(req: ChatRequest) -> StreamingResponse:
    trace_id = uuid.uuid4().hex[:16]

    def sse(event: str, payload: dict) -> str:
        return f"event: {event}\ndata: {json.dumps(payload, ensure_ascii=False)}\n\n"

    async def generator():
        state: dict = {}
        parts: list[str] = []
        started = time.perf_counter()
        try:
            async for kind, payload in _agent.stream(
                req.message, history=_history(req),
                product_id=_product_id(req), conversation_id=req.conversation_id,
            ):
                if kind == "__state__":
                    state = payload  # type: ignore[assignment]
                    yield sse("meta", {
                        "intent": state.get("intent"),
                        "occupation": state.get("occupation"),
                        "tools": state.get("tools", []),
                        "elapsedMs": int((time.perf_counter() - started) * 1000),
                        "traceId": trace_id,
                    })
                else:
                    token = str(payload)
                    parts.append(token)
                    yield sse("delta", {"text": token})
        except Exception:
            logger.exception("stream failed trace=%s", trace_id)
            yield sse("error", {"message": "对话服务内部错误", "traceId": trace_id})
            return

        answer = "".join(parts)
        state = _agent.finalize(state, answer)
        # 合规替换过的文本以 final 事件下发，前端覆盖已渲染内容
        yield sse("final", {"answer": state.get("answer", answer)})
        yield sse("citations", {"citations": state.get("citations", [])})
        yield sse("done", {"traceId": trace_id})
        state["elapsed_ms"] = int((time.perf_counter() - started) * 1000)
        _save(req, trace_id, state)

    return StreamingResponse(
        generator(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "X-Accel-Buffering": "no"},
    )
