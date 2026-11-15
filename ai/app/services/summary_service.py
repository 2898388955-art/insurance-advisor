"""长会话记忆压缩：超出阈值后把较早轮次压成一段摘要。

策略：保留最近 4 轮原文，更早的轮次每累计 4 轮压缩一次，
摘要与「已覆盖到哪条快照」一起存表，避免重复摘要。
"""
from __future__ import annotations

import logging

import pymysql

from app.config import settings
from app.llm.client import ChatClient, LlmError
from app.services.checkpoint_service import CheckpointService

logger = logging.getLogger(__name__)

KEEP_RECENT = 4
TRIGGER_EVERY = 4
MIN_TURNS = 6

SUMMARY_PROMPT = (
    "把以下保险顾问对话压缩成不超过 120 字的中文摘要。"
    "保留：用户关注的产品、年龄与职业、预算或约束、已经确认的结论。"
    "不要编造未出现的信息，不要加入建议。只输出摘要正文。"
)


class SummaryService:
    def __init__(self, checkpoints: CheckpointService | None = None,
                 llm: ChatClient | None = None) -> None:
        self.checkpoints = checkpoints or CheckpointService()
        self.llm = llm or ChatClient()

    async def maybe_summarize(self, conversation_id: int) -> None:
        total = self.checkpoints.count(conversation_id)
        if total < MIN_TURNS or total % TRIGGER_EVERY != 0:
            return
        rows = self.checkpoints.older_than_recent(conversation_id, KEEP_RECENT)
        if not rows:
            return
        transcript = "\n".join(
            f"用户：{r['question']}\n顾问：{(r['answer'] or '')[:400]}" for r in rows)
        try:
            summary = await self.llm.complete([
                {"role": "system", "content": SUMMARY_PROMPT},
                {"role": "user", "content": transcript[:6000]},
            ])
        except LlmError as e:
            logger.warning("summarize failed: %s", e)
            return
        self._upsert(conversation_id, summary.strip(), rows[-1]["id"])
        logger.info("summarized conversation=%s turns=%s", conversation_id, len(rows))

    def history(self, conversation_id: int) -> list[dict]:
        """摘要 + 最近几轮原文，作为下一轮的对话历史。"""
        messages: list[dict] = []
        summary = self._load_summary(conversation_id)
        if summary:
            messages.append({"role": "system",
                             "content": "此前对话摘要：" + summary})
        for row in self.checkpoints.recent(conversation_id, KEEP_RECENT):
            messages.append({"role": "user", "content": row["question"]})
            if row.get("answer"):
                messages.append({"role": "assistant", "content": row["answer"]})
        return messages

    def _load_summary(self, conversation_id: int) -> str | None:
        conn = pymysql.connect(**settings.mysql_dsn)
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT summary FROM conversation_summary WHERE conversation_id=%s",
                            (conversation_id,))
                row = cur.fetchone()
                return row[0] if row else None
        finally:
            conn.close()

    def _upsert(self, conversation_id: int, summary: str, covered_id: int) -> None:
        conn = pymysql.connect(**settings.mysql_dsn)
        try:
            with conn.cursor() as cur:
                cur.execute(
                    """INSERT INTO conversation_summary
                       (conversation_id, summary, covered_checkpoint_id)
                       VALUES (%s,%s,%s)
                       ON DUPLICATE KEY UPDATE summary=VALUES(summary),
                           covered_checkpoint_id=VALUES(covered_checkpoint_id)""",
                    (conversation_id, summary, covered_id),
                )
            conn.commit()
        finally:
            conn.close()
