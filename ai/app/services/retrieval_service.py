"""条款检索：Milvus 召回子块 → MySQL 回填父块。

为什么回填父块：子块（约 300 字）用于精确召回，但生成答案需要完整上下文；
父块是一整节条款，回填后既保留细节又避免断章取义。
"""
from __future__ import annotations

import asyncio

import pymysql

from app.config import settings
from app.rag.embedder import OllamaEmbedder
from app.rag.fusion import weighted_rrf
from app.rag.milvus_store import COLLECTION, get_client

OUTPUT_FIELDS = ["doc_id", "product_id", "parent_id", "heading_path", "page_no", "text"]


class RetrievalService:
    def __init__(self) -> None:
        self.embedder = OllamaEmbedder()
        self.client = get_client()

    async def retrieve(self, query: str, top_k: int | None = None,
                       product_id: int | None = None) -> list[dict]:
        top_k = top_k or settings.retrieval_top_k
        vector = await asyncio.to_thread(self.embedder.embed_one, query)
        hits = await asyncio.to_thread(
            self._search, query, vector, top_k, self._filter_expr(product_id))
        if not hits:
            return []
        parents = await asyncio.to_thread(self._load_parents, [h["parent_id"] for h in hits])
        for h in hits:
            h["parent_content"] = parents.get(h["parent_id"], h["text"])
        return hits

    @staticmethod
    def _filter_expr(product_id: int | None) -> str | None:
        return f"product_id == {int(product_id)}" if product_id else None

    def _search(self, query: str, vector: list[float], top_k: int,
                expr: str | None) -> list[dict]:
        candidates = max(top_k * 4, settings.retrieval_candidates)
        dense = (self._search_dense(vector, candidates, expr)
                 if settings.retrieval_dense_weight > 0 else [])
        sparse = (self._search_sparse(query, candidates, expr)
                  if settings.retrieval_sparse_weight > 0 else [])

        fused = weighted_rrf(
            [self._fusion_hit(h) for h in dense],
            [self._fusion_hit(h) for h in sparse],
            k=settings.retrieval_rrf_k,
            dense_weight=settings.retrieval_dense_weight,
            sparse_weight=settings.retrieval_sparse_weight,
            limit=top_k,
        )
        return [self._to_hit(hit) for hit in fused]

    def _search_dense(self, vector: list[float], limit: int,
                      expr: str | None) -> list[dict]:
        return self.client.search(
            COLLECTION, data=[vector], anns_field="embedding", limit=limit,
            filter=expr or "", output_fields=OUTPUT_FIELDS,
            search_params={"metric_type": "COSINE", "params": {"ef": 64}},
        )[0]

    def _search_sparse(self, query: str, limit: int, expr: str | None) -> list[dict]:
        return self.client.search(
            COLLECTION, data=[query], anns_field="sparse", limit=limit,
            filter=expr or "", output_fields=OUTPUT_FIELDS,
            search_params={"metric_type": "BM25"},
        )[0]

    @staticmethod
    def _fusion_hit(hit: dict) -> dict:
        return {"id": int(hit["id"]), "entity": hit["entity"]}

    @staticmethod
    def _to_hit(hit: dict) -> dict:
        e = hit["entity"]
        return {
            "chunk_id": hit["id"],
            "score": float(hit["score"]),
            "doc_id": e["doc_id"],
            "product_id": int(e["product_id"]),
            "parent_id": int(e["parent_id"]),
            "heading_path": e["heading_path"],
            "page_no": int(e["page_no"]),
            "text": e["text"],
        }

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
