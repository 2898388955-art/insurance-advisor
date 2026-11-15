"""导入产品价格/费率数据（阶段 2.5）。

原则：
- price_display 只做展示，缺失统一兜底为「产品价格未公开」
- 只有「金额型费率表（直接给基准保费）」的数值才写入 min_premium/max_premium 参与预算筛选
- 单位保额型、公式系数型、仅有保额表的，一律不参与价格筛选，避免误导

用法：
    python -m app.import.import_prices --source D:/WorkBuddy/2026-11-12-09-01-03
"""
from __future__ import annotations

import argparse
import csv
import json
from decimal import Decimal, InvalidOperation
from pathlib import Path

import pymysql
from pymysql.constants import CLIENT

from app.config import settings

FALLBACK = "产品价格未公开"


def status_of(text: str) -> str:
    t = text or ""
    if "已取得官方费率表" in t:
        return "PUBLISHED"
    if "仅有基本保险金额表" in t:
        return "NO_RATE_TABLE"
    if "不适用" in t:
        return "NOT_APPLICABLE"
    return "NOT_PUBLIC"


def dec(value: str) -> Decimal | None:
    v = (value or "").strip().replace(",", "")
    if not v:
        return None
    try:
        return Decimal(v)
    except InvalidOperation:
        return None


def clip(v: str | None, n: int) -> str | None:
    v = (v or "").strip()
    return v[:n] if v else None


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    args = ap.parse_args()
    rows = list(csv.DictReader((Path(args.source) / "insurance_prices.csv").open(encoding="utf-8-sig")))

    # FOUND_ROWS：值未变化时 rowcount 仍返回匹配行数，避免误报 missing
    conn = pymysql.connect(**settings.mysql_dsn, client_flag=CLIENT.FOUND_ROWS)
    summary = {"total": len(rows), "published": 0, "fallback": 0, "amount_type": 0, "missing_product": []}
    try:
        with conn.cursor() as cur:
            for r in rows:
                pid = r["product_id"]
                status = status_of(r["status"])
                # 未取得/不适用时统一兜底；只展示，不影响字段事实
                display = ((r["price_display"] or "").strip() or FALLBACK) if status == "PUBLISHED" else FALLBACK
                pmin, pmax = dec(r["price_min"]), dec(r["price_max"])
                # 费率口径不统一（年/月/每万元保额），数值不参与预算筛选
                is_amount = False

                cur.execute("""UPDATE product SET
                        price_display=%s, price_status=%s, price_type=%s,
                        price_case=%s, rate_doc_path=%s, price_min=%s, price_max=%s,
                        min_premium=%s, max_premium=%s
                    WHERE external_id=%s""",
                    (clip(display, 300), status, clip(r["price_type"], 64),
                     clip(r["case_premium"] or r["case_desc"], 300),
                     clip(r["rate_local"], 300), pmin, pmax,
                     pmin if is_amount else None, pmax if is_amount else None,
                     pid))
                if cur.rowcount == 0:
                    summary["missing_product"].append(pid)
                    continue
                summary["published"] += status == "PUBLISHED"
                summary["fallback"] += status != "PUBLISHED"
                summary["amount_type"] += is_amount
        conn.commit()
    finally:
        conn.close()

    print(json.dumps(summary, ensure_ascii=False))


if __name__ == "__main__":
    main()
