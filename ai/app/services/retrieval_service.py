"""条款检索：Milvus 召回子块 → MySQL 回填父块。

为什么回填父块：子块（约 300 字）用于精确召回，但生成答案需要完整上下文；
父块是一整节条款，回填后既保留细节又避免断章取义。
"""
from __future__ import annotations

import asyncio
import logging

import pymysql

from app.config import settings
from app.rag.embedder import OllamaEmbedder
from app.rag.milvus_store import COLLECTION, get_client

logger = logging.getLogger(__name__)


class RetrievalService:
    def __init__(self) -> None:
        self.embedder = OllamaEmbedder()
        self.client = get_client()

    async def retrieve(self, query: str, top_k: int | None = None,
                       product_id: int | None = None) -> list[dict]:
        top_k = top_k or settings.retrieval_top_k
        vector = await asyncio.to_thread(self.embedder.embed_one, query)
        expr = f"product_id == {int(product_id)}" if product_id else None
        hits = await asyncio.to_thread(self._search, vector, top_k, expr)
        if not hits:
            return []
        parents = await asyncio.to_thread(self._load_parents, [h["parent_id"] for h in hits])
        for h in hits:
            h["parent_content"] = parents.get(h["parent_id"], h["text"])
        return hits

    def _search(self, vector: list[float], top_k: int, expr: str | None) -> list[dict]:
        # pymilvus 3.x 用 filter 参数，不是 expr（expr 会落进 **kwargs 触发冲突）
        res = self.client.search(
            COLLECTION, data=[vector], anns_field="embedding", limit=top_k,
            filter=expr or "", output_fields=["doc_id", "product_id", "parent_id",
                                              "heading_path", "page_no", "text"],
        )
        out = []
        for hit in res[0]:
            e = hit["entity"]
            out.append({
                "chunk_id": int(hit["id"]),
                "score": float(hit["distance"]),
                "doc_id": e["doc_id"],
                "product_id": int(e["product_id"]),
                "parent_id": int(e["parent_id"]),
                "heading_path": e["heading_path"],
                "page_no": int(e["page_no"]),
                "text": e["text"],
            })
        return out

    def _load_parents(self, parent_ids: list[int]) -> dict[int, str]:
        if not parent_ids:
            return {}
        conn = pymysql.connect(**settings.mysql_dsn)
        try:
            with conn.cursor() as cur:
                marks = ",".join(["%s"] * len(parent_ids))
                cur.execute(f"SELECT id, content FROM clause_parent WHERE id IN ({marks})",
                            tuple(parent_ids))
                return {int(i): c for i, c in cur.fetchall()}
        finally:
            conn.close()


def build_context(hits: list[dict]) -> str:
    """把检索结果拼成带编号的上下文，编号与引用卡片一致。"""
    parts = []
    for i, h in enumerate(hits, 1):
        parts.append(f"[{i}] {h['heading_path']}（第 {h['page_no']} 页）\n{h['parent_content']}")
    return "\n\n".join(parts)
