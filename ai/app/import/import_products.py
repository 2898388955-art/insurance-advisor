"""阶段 1+2：导入 48 条产品公开数据与产品图。

设计要点：
- 以源数据 product_id 作为 external_id 幂等键，可重复执行
- 单行原始数据写入 product_import_raw，便于回溯
- 「待核验」字段一律不落库，避免把推测当事实
- 条款文件按 product_id 命名复制到 data/raw/clauses，图片同理

用法：
    python -m app.import.import_products --source D:/WorkBuddy/2026-11-12-09-01-03
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import shutil
from pathlib import Path

import pymysql

from app.config import settings

BATCH = "2026-11-13"
ROOT = Path(__file__).resolve().parents[3]          # 项目根目录
RAW = ROOT / "data" / "raw"

# 源产品类型 -> 我们的分类 ID
CATEGORY_RULES = [
    (("车", "机动车辆"), 81),
    (("门急诊",), 22),
    (("住院", "医疗", "药械", "药品"), 21),
    (("重疾", "重大疾病", "特疾", "特定疾病", "疾病"), 31),
    (("意外",), 11),
    (("教育",), 51),
    (("年金", "养老", "两全"), 52),
    (("寿险",), 41),
]


def clip(value: str | None, limit: int) -> str | None:
    value = clean(value)
    return value[:limit] if value else None


def clean(value: str | None) -> str | None:
    """把空串与「待核验」类占位符变成 NULL。"""
    if value is None:
        return None
    v = value.strip()
    # 任何包含「待核验/待分类」的字段都不作为事实入库（原文保留在 product_import_raw）
    if not v or "待核验" in v or "待分类" in v:
        return None
    return v


def map_category(product_type: str | None, l2: str | None) -> int:
    text = f"{product_type or ''} {l2 or ''}"
    for keys, cid in CATEGORY_RULES:
        if any(k in text for k in keys):
            return cid
    return 99


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True, help="源数据目录（含 csv / clause_docs / product_images）")
    args = ap.parse_args()
    src = Path(args.source)

    rows = list(csv.DictReader((src / "insurance_products.csv").open(encoding="utf-8-sig")))
    (RAW / "clauses").mkdir(parents=True, exist_ok=True)
    (RAW / "images").mkdir(parents=True, exist_ok=True)

    conn = pymysql.connect(**settings.mysql_dsn)
    summary = {"batch": BATCH, "total": len(rows), "imported": 0,
               "with_clause": 0, "no_clause": 0, "images": 0, "unmapped": []}
    try:
        with conn.cursor() as cur:
            for r in rows:
                pid = r["product_id"]
                clause_src = next((src / "clause_docs" / f"{pid}{ext}"
                                   for ext in (".pdf", ".docx")
                                   if (src / "clause_docs" / f"{pid}{ext}").exists()), None)
                image_src = src / "product_images" / f"{pid}.png"

                # 复制原始文件到项目 data/raw（不提交仓库）
                clause_dst = None
                if clause_src:
                    clause_dst = RAW / "clauses" / clause_src.name
                    shutil.copy2(clause_src, clause_dst)
                if image_src.exists():
                    shutil.copy2(image_src, RAW / "images" / image_src.name)
                    summary["images"] += 1

                data_status = "VERIFIED" if clause_dst else "NO_CLAUSE"
                category_id = map_category(r["product_type"], r["category_l2"])
                if category_id == 99:
                    summary["unmapped"].append(pid)
                issuer_type = "INDUSTRY_STANDARD" if "示范条款" in r["marketing_name"] else "INSURER"

                # 幂等：只按 external_id 匹配。
                # 不用名称兜底：Z01/Z02 营销名相同（同一计划的主险+附加险），按名称会误合并。
                cur.execute("SELECT id FROM product WHERE external_id=%s", (pid,))
                found = cur.fetchone()

                fields = dict(
                    name=clip(r["marketing_name"], 120),
                    company=clip(r["company"], 120),
                    category_id=category_id,
                    product_type=clip(r["product_type"], 64),
                    highlights=clip(r["core_coverage"], 500),
                    registration_no=clip(r["registration_no"], 100),
                    sale_status=clip(r["sale_status"], 100),
                    issuer_type=issuer_type,
                    data_status=data_status,
                    source_url=clip(r["source_page_url"], 500),
                    import_batch=BATCH,
                )

                if found:
                    product_id = found[0]
                    sets = ", ".join(f"{k}=%s" for k in fields)
                    cur.execute(f"UPDATE product SET {sets} WHERE id=%s",
                                (*fields.values(), product_id))
                else:
                    cols = ", ".join(fields)
                    marks = ", ".join(["%s"] * len(fields))
                    cur.execute(
                        f"INSERT INTO product (external_id, code, status, {cols}) "
                        f"VALUES (%s,%s,1,{marks})",
                        (pid, f"SRC-{pid}", *fields.values()))
                    product_id = cur.lastrowid

                cur.execute("UPDATE product SET external_id=%s WHERE id=%s AND (external_id IS NULL OR external_id='')",
                            (pid, product_id))

                # 条款记录
                if clause_dst:
                    digest = sha256(clause_dst)
                    doc_id = digest[:16]
                    cur.execute("SELECT id FROM product_clause WHERE doc_id=%s", (doc_id,))
                    pc = cur.fetchone()
                    if pc:
                        cur.execute("""UPDATE product_clause
                            SET product_id=%s, file_path=%s, file_hash=%s, file_type=%s,
                                clause_name=%s, reg_no=%s
                            WHERE id=%s""",
                            (product_id, str(clause_dst.relative_to(ROOT)).replace("\\", "/"),
                             digest, clause_dst.suffix.lstrip(".").upper(),
                             clean(r["clause_name"]), clean(r["registration_no"]), pc[0]))
                    else:
                        cur.execute("""INSERT INTO product_clause
                            (product_id, doc_id, version, file_path, file_hash, page_count,
                             status, file_type, clause_name, reg_no)
                            VALUES (%s,%s,'v1',%s,%s,NULL,'PENDING',%s,%s,%s)""",
                            (product_id, doc_id,
                             str(clause_dst.relative_to(ROOT)).replace("\\", "/"),
                             digest, clause_dst.suffix.lstrip(".").upper(),
                             clean(r["clause_name"]), clean(r["registration_no"])))
                    summary["with_clause"] += 1
                else:
                    summary["no_clause"] += 1

                cur.execute("INSERT INTO product_import_raw (batch_id, external_id, raw_json) VALUES (%s,%s,%s)",
                            (BATCH, pid, json.dumps(r, ensure_ascii=False)))
                summary["imported"] += 1
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

    out = ROOT / "data" / "import" / "import_summary.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({k: v for k, v in summary.items() if k != "unmapped"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
