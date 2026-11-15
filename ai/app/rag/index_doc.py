"""把 MySQL 里的子块向量化并写入 Milvus。

用法：
    python -m app.rag.index_doc --doc-id 4ef195533eb264f1 [--rebuild]
"""
from __future__ import annotations

import argparse
import json

import pymysql

from app.config import settings
from app.rag.embedder import OllamaEmbedder
from app.rag.milvus_store import COLLECTION, ensure_collection, get_client, reset_collection


def load_children(doc_id: str) -> list[dict]:
    conn = pymysql.connect(**settings.mysql_dsn)
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(
                """SELECT id, doc_id, product_id, parent_id, heading_path, page_no, content
                   FROM clause_child WHERE doc_id=%s ORDER BY id""",
                (doc_id,),
            )
            return cur.fetchall()
    finally:
        conn.close()


def mark_indexed(ids: list[int]) -> None:
    if not ids:
        return
    conn = pymysql.connect(**settings.mysql_dsn)
    try:
        with conn.cursor() as cur:
            cur.executemany(
                "UPDATE clause_child SET vector_id=%s WHERE id=%s",
                [(str(i), i) for i in ids],
            )
        conn.commit()
    finally:
        conn.close()


def index(doc_id: str, rebuild: bool = False) -> dict:
    rows = load_children(doc_id)
    if not rows:
        return {"error": "no children"}

    client = get_client()
    if rebuild:
        reset_collection(client)
    ensure_collection(client)

    embedder = OllamaEmbedder()
    vectors = embedder.embed([r["content"] for r in rows])

    data = [
        {
            "id": r["id"],
            "doc_id": r["doc_id"],
            "product_id": r["product_id"],
            "parent_id": r["parent_id"],
            "heading_path": r["heading_path"] or "",
            "page_no": r["page_no"],
            "text": r["content"],
            "embedding": vec,
        }
        for r, vec in zip(rows, vectors)
    ]
    # 重跑时先删旧向量，否则会残留旧块（子块 ID 会变）
    client.delete(COLLECTION, filter=f'doc_id == "{doc_id}"')
    client.insert(COLLECTION, data)
    client.flush(COLLECTION)
    mark_indexed([r["id"] for r in rows])

    return {"doc_id": doc_id, "indexed": len(data),
            "collection_total": client.get_collection_stats(COLLECTION).get("row_count")}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--doc-id", required=True)
    ap.add_argument("--rebuild", action="store_true")
    args = ap.parse_args()
    print(json.dumps(index(args.doc_id, args.rebuild), ensure_ascii=False))


if __name__ == "__main__":
    main()
