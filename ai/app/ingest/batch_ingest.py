"""阶段 3：批量解析条款（PDF / DOCX）→ 父子块 → 向量索引。

可断点续跑：只处理 status='PENDING' 的记录；失败的置为 FAILED 并保留错误信息。

用法：
    python -m app.ingest.batch_ingest [--limit N] [--retry-failed]
"""
from __future__ import annotations

import argparse
import os
import subprocess
import time
import traceback
from pathlib import Path

import pymysql
from docx import Document

from app.config import settings
from app.ingest.run_ingest import ingest
from app.rag.index_doc import index

ROOT = Path(__file__).resolve().parents[3]
PARSED = ROOT / "data" / "parsed"
MINERU = ROOT / "ai" / ".venv" / "Scripts" / "mineru.exe"
MINERU_HOME = r"D:\dev-runtime\mineru"
LOG = ROOT / "data" / "import" / "batch_ingest.log"


def log(line: str) -> None:
    LOG.parent.mkdir(parents=True, exist_ok=True)
    ts = time.strftime("%H:%M:%S")
    with LOG.open("a", encoding="utf-8") as f:
        f.write(f"[{ts}] {line}\n")
    print(line, flush=True)


def docx_to_md(src: Path, out: Path) -> None:
    """MinerU 不支持 docx，用 python-docx 降级抽取，保留标题层级。"""
    doc = Document(str(src))
    lines: list[str] = []
    for p in doc.paragraphs:
        text = p.text.strip()
        if not text:
            continue
        style = (p.style.name or "") if p.style is not None else ""
        # 兼容英文 Heading 1 与中文 Word 的「标题 1」
        if style.lower().startswith("heading") or style.startswith("标题"):
            digits = "".join(ch for ch in style if ch.isdigit())
            level = min(int(digits) if digits else 2, 3)
            lines.append("#" * level + " " + text)
        else:
            lines.append(text)
    out.write_text("\n\n".join(lines), encoding="utf-8")


def parse_pdf(src: Path, out: Path) -> None:
    env = os.environ.copy()
    env["MINERU_HOME"] = MINERU_HOME
    cmd = [str(MINERU), "parse", str(src), "--tier", "flash", "--pages", "all",
           "-o", str(out), "--wait", "1800"]
    r = subprocess.run(cmd, capture_output=True, text=True, env=env, timeout=1900)
    # MinerU 出错时也可能返回 0，必须以产物是否存在为准
    if not out.exists() or out.stat().st_size < 200:
        raise RuntimeError((r.stdout or r.stderr or "no output")[-500:])


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--retry-failed", action="store_true")
    args = ap.parse_args()

    conn = pymysql.connect(**settings.mysql_dsn)
    conn.autocommit(True)
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            statuses = "('PENDING','FAILED')" if args.retry_failed else "('PENDING')"
            cur.execute(f"""SELECT id, doc_id, product_id, file_path, file_type
                            FROM product_clause WHERE status IN {statuses}
                            ORDER BY id""")
            tasks = cur.fetchall()
            if args.limit:
                tasks = tasks[:args.limit]
            log(f"batch start: {len(tasks)} clauses")

            ok = failed = 0
            for i, t in enumerate(tasks, 1):
                doc_id = t["doc_id"]
                src = ROOT / t["file_path"]
                md = PARSED / f"{doc_id}.md"
                started = time.time()
                try:
                    cur.execute("UPDATE product_clause SET status='PARSING' WHERE id=%s", (t["id"],))
                    if not src.exists():
                        raise FileNotFoundError(str(src))
                    if t["file_type"] == "DOCX":
                        docx_to_md(src, md)
                    else:
                        parse_pdf(src, md)
                    stats = ingest(str(md), doc_id, t["product_id"])
                    index(doc_id)
                    cur.execute("UPDATE product_clause SET status='DONE' WHERE id=%s", (t["id"],))
                    ok += 1
                    log(f"[{i}/{len(tasks)}] {doc_id} DONE parents={stats['parents']} "
                        f"children={stats['children']} {time.time()-started:.0f}s")
                except Exception as e:
                    failed += 1
                    msg = f"{type(e).__name__}: {e}"
                    cur.execute("UPDATE product_clause SET status='FAILED' WHERE id=%s", (t["id"],))
                    cur.execute("""INSERT INTO ingest_task
                                   (doc_id, product_id, status, step, err_msg, started_at, finished_at)
                                   VALUES (%s,%s,'FAILED','parse',%s,NOW(),NOW())""",
                                (doc_id, t["product_id"], msg[:1000]))
                    log(f"[{i}/{len(tasks)}] {doc_id} FAILED {msg[:200]}")
                    log(traceback.format_exc()[-500:])
            log(f"batch done: ok={ok} failed={failed}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
