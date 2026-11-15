"""从已入库条款自动构建评测集。

ground truth 不依赖向量检索结果：按「章节标题 + 关键词」定位相关块，
避免用被测系统自己的召回结果当标准答案。
"""
from __future__ import annotations

import json
from pathlib import Path

import pymysql

from app.config import settings

OUT = Path(__file__).resolve().parents[3] / "data" / "eval" / "questions.jsonl"

FIELDS = [
    ("等待期是多久？", "等待期", "等待期"),
    ("免赔额是怎么规定的？", "免赔额", "免赔额"),
    ("哪些情况不赔？", "责任免除", "责任免除|不承担|除外"),
    ("赔付比例是多少？", "赔付比例", "赔付比例"),
    ("投保年龄范围是什么？", "投保年龄", "投保年龄|周岁"),
    ("续保条件是什么？", "续保", "续保"),
]

# 语义改写题：不出现章节关键词，测试语义召回
PARAPHRASE = [
    ("这款产品生效后多久内确诊疾病不赔？", "等待期", "等待期"),
    ("每次看门诊自己要掏多少钱？", "免赔额", "免赔额"),
    ("被保险人故意犯罪导致的事故能赔吗？", "责任免除", "故意犯罪"),
    ("住院天数有没有上限？", "赔付", "住院|日数|天数"),
    ("明年还能不能接着买？", "续保", "续保"),
]


def main() -> None:
    conn = pymysql.connect(**settings.mysql_dsn, cursorclass=pymysql.cursors.DictCursor)
    rows: list[dict] = []
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT p.id AS product_id, p.name, pc.doc_id
                FROM product p JOIN product_clause pc ON pc.product_id = p.id
                WHERE p.status = 1 AND pc.status = 'DONE'
                ORDER BY p.id
            """)
            products = cur.fetchall()

            qid = 1
            for p in products:
                for template, section, keyword in FIELDS:
                    if len(rows) >= 55:
                        break
                    like_kw = f"%{keyword.split('|')[0]}%"
                    cur.execute("""
                        SELECT id, heading_path, content, page_no FROM clause_child
                        WHERE doc_id=%s AND (heading_path LIKE %s OR content LIKE %s)
                        LIMIT 1
                    """, (p["doc_id"], f"%{section}%", like_kw))
                    if not cur.fetchone():
                        continue
                    rows.append({
                        "id": f"q{qid:03d}",
                        # 产品内检索：省略产品名，避免词频噪声
                        "question": template,
                        # 全局检索：带上产品名，靠语义/关键词定位产品
                        "question_global": f"{p['name']}的{template}",
                        "product_id": p["product_id"], "doc_id": p["doc_id"],
                        "intent": "rag", "expected_section": section,
                        "expected_keyword": keyword,
                    })
                    qid += 1

            # 语义改写题绑定到 T01（doc 4ef195533eb264f1）
            cur.execute("""SELECT product_id, doc_id FROM product_clause
                           WHERE doc_id='4ef195533eb264f1' LIMIT 1""")
            t01 = cur.fetchone()
            for text, section, keyword in PARAPHRASE:
                rows.append({
                    "id": f"q{qid:03d}", "question": text,
                    "question_global": text,
                    "product_id": t01["product_id"] if t01 else None,
                    "doc_id": t01["doc_id"] if t01 else None,
                    "intent": "rag", "expected_section": section,
                    "expected_keyword": keyword,
                })
                qid += 1
    finally:
        conn.close()

    # 路由评测（不需要产品上下文）
    router_cases = [
        ("我 30 岁，想买医疗险，有推荐吗", "advisor"),
        ("预算 3000，适合什么保险", "advisor"),
        ("这款和另一款哪个好", "compare"),
        ("帮我比较一下两个产品的区别", "compare"),
        ("你好", "chitchat"),
        ("谢谢", "chitchat"),
        ("等待期是多久", "rag"),
        ("哪些情况不赔", "rag"),
    ]
    for text, intent in router_cases:
        rows.append({
            "id": f"q{qid:03d}", "question": text, "question_global": text,
            "product_id": None, "doc_id": None,
            "intent": intent, "expected_section": None, "expected_keyword": None,
        })
        qid += 1

    OUT.parent.mkdir(parents=True, exist_ok=True)
    with OUT.open("w", encoding="utf-8") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    print(json.dumps({"total": len(rows), "rag": sum(1 for r in rows if r["intent"] == "rag"),
                      "router": sum(1 for r in rows if r["intent"] != "rag")}, ensure_ascii=False))


if __name__ == "__main__":
    main()
