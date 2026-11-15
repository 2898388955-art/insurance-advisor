"""把归一化后的条款写入 MySQL（父块 + 子块）。

用法：
    python -m app.ingest.run_ingest data/parsed/86803.md --doc-id 4ef195533eb264f1 --product-id 1
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import pymysql

from app.config import settings
from app.ingest.chunker import body_precedes_heading, build_children, build_parents
from app.ingest.normalize import load


def ingest(md_path: str, doc_id: str, product_id: int) -> dict:
    blocks = load(md_path)
    shifted = body_precedes_heading(blocks)
    parents = build_parents(blocks, body_before_heading=shifted)
    children = build_children(parents)

    conn = pymysql.connect(**settings.mysql_dsn)
    try:
        with conn.cursor() as cur:
            # 幂等：同一文档重跑先清空
            cur.execute("DELETE cc FROM clause_child cc WHERE cc.doc_id = %s", (doc_id,))
            cur.execute("DELETE cp FROM clause_parent cp WHERE cp.doc_id = %s", (doc_id,))

            parent_ids: list[int] = []
            for seq, p in enumerate(parents):
                cur.execute(
                    """INSERT INTO clause_parent
                       (doc_id, product_id, heading_path, content, page_from, page_to, seq)
                       VALUES (%s,%s,%s,%s,%s,%s,%s)""",
                    (doc_id, product_id, p.heading_path or "(前言)",
                     p.content, p.page_from, p.page_to, seq),
                )
                parent_ids.append(cur.lastrowid)

            for c in children:
                cur.execute(
                    """INSERT INTO clause_child
                       (parent_id, doc_id, product_id, heading_path, content, token_cnt, page_no)
                       VALUES (%s,%s,%s,%s,%s,%s,%s)""",
                    (parent_ids[c.parent_index], doc_id, product_id,
                     c.heading_path, c.content, c.token_cnt, c.page_no),
                )

            cur.execute(
                """UPDATE product_clause
                   SET status='DONE', updated_at=NOW()
                   WHERE doc_id=%s""", (doc_id,))
            cur.execute(
                """INSERT INTO ingest_task
                   (doc_id, product_id, status, step, started_at, finished_at)
                   VALUES (%s,%s,'DONE','chunked',NOW(),NOW())""",
                (doc_id, product_id))
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

    return {"blocks": len(blocks), "body_before_heading": shifted,
            "parents": len(parents), "children": len(children)}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("markdown")
    ap.add_argument("--doc-id", required=True)
    ap.add_argument("--product-id", type=int, required=True)
    args = ap.parse_args()

    result = ingest(args.markdown, args.doc_id, args.product_id)
    out = Path(args.markdown).with_suffix(".ingest.json")
    out.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))


if __name__ == "__main__":
    sys.exit(main())
