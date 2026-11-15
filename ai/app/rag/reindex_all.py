"""重建全部已入库条款的向量索引（索引结构变更后使用）。"""
from __future__ import annotations

import json

import pymysql

from app.config import settings
from app.rag.index_doc import index
from app.rag.milvus_store import get_client, reset_collection


def main() -> None:
    conn = pymysql.connect(**settings.mysql_dsn)
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT doc_id FROM product_clause WHERE status='DONE' ORDER BY id")
            docs = [r[0] for r in cur.fetchall()]
    finally:
        conn.close()

    client = get_client()
    reset_collection(client)

    total = 0
    for doc_id in docs:
        result = index(doc_id)
        total += result.get("indexed", 0)
        print(f"{doc_id} indexed={result.get('indexed')}", flush=True)
    print(json.dumps({"docs": len(docs), "chunks": total}, ensure_ascii=False))


if __name__ == "__main__":
    main()
