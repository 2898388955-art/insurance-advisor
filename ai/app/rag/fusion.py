"""加权 RRF（Reciprocal Rank Fusion）。

Milvus 自带的 RRFRanker 只支持等权；条款场景下 dense 明显强于 BM25，
因此把融合放在应用层，用权重控制两路贡献：

    score(doc) = Σ weight_i / (k + rank_i)

未出现在某一路的文档，该路贡献为 0。
"""
from __future__ import annotations


def weighted_rrf(dense_hits: list[dict], sparse_hits: list[dict], *,
                 k: int = 60, dense_weight: float = 0.8,
                 sparse_weight: float = 0.2, limit: int = 10) -> list[dict]:
    scores: dict[int, float] = {}
    payload: dict[int, dict] = {}

    for rank, hit in enumerate(dense_hits, 1):
        key = hit["id"]
        scores[key] = scores.get(key, 0.0) + dense_weight / (k + rank)
        payload.setdefault(key, hit)

    for rank, hit in enumerate(sparse_hits, 1):
        key = hit["id"]
        scores[key] = scores.get(key, 0.0) + sparse_weight / (k + rank)
        payload.setdefault(key, hit)

    ordered = sorted(scores.items(), key=lambda kv: (-kv[1], kv[0]))[:limit]
    return [{"id": key, "score": score, "entity": payload[key]["entity"]}
            for key, score in ordered]
