"""合规检查：拦截绝对化表述、强制附免责声明。

规则优先于模型：合规是硬约束，不能交给 LLM 自行判断。
"""
from __future__ import annotations

import re

DISCLAIMER = "以上内容基于公开条款整理，仅供参考，不构成投保建议；投保前请以保险公司正式条款为准。"

# 绝对化/承诺性表述，命中后替换为中性说法
BANNED_PATTERNS = [
    (re.compile(r"稳赚不赔|保证收益|一定赔|绝对赔|百分百赔付"), "条款未作此类承诺"),
    (re.compile(r"最好的产品|最优选择"), "需结合个人情况判断"),
]


class ComplianceService:
    def check(self, answer: str) -> tuple[str, list[str]]:
        warnings: list[str] = []
        for pattern, replacement in BANNED_PATTERNS:
            if pattern.search(answer):
                warnings.append(f"removed:{pattern.pattern}")
                answer = pattern.sub(replacement, answer)
        if DISCLAIMER not in answer:
            answer = answer.rstrip() + "\n\n" + DISCLAIMER
        return answer, warnings
