"""长会话记忆压缩：超出阈值后把较早轮次压成一段摘要。

策略：
- 最近 KEEP_RECENT 轮保留原文，不参与压缩；
- 总轮次达到 MIN_TURNS 后，每 TRIGGER_EVERY 轮触发一次摘要；
- 每次把「最近 KEEP_RECENT 轮以外」的历史整体重新压缩，覆盖旧摘要，
  同时记录已覆盖的最后一条快照 id。
"""
from __future__ import annotations

import logging

import pymysql

from app.config import settings
from app.llm.client import ChatClient, LlmError
from app.services.checkpoint_service import CheckpointService

logger = logging.getLogger(__name__)

# 触发节奏：总轮次 >= 6 且是 4 的倍数时摘要（即第 8、12、16... 轮）。
KEEP_RECENT = 4
TRIGGER_EVERY = 4
MIN_TURNS = 6

# 单次摘要请求的输入上限：每条回答先截断，再限制整段对话长度，控制 token。
ANSWER_LIMIT = 400
TRANSCRIPT_LIMIT = 6000

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
        """轮到触发节奏时压缩较早对话；失败只记日志，不影响本轮回复。"""
        total = self.checkpoints.count(conversation_id)
        if not self._should_summarize(total):
            return

        rows = self.checkpoints.older_than_recent(conversation_id, KEEP_RECENT)
        if not rows:
            return

        summary = await self._summarize(self._transcript(rows))
        if summary is None:
            return

        self._upsert(conversation_id, summary, rows[-1]["id"])
        logger.info("summarized conversation=%s turns=%s", conversation_id, len(rows))

    @staticmethod
    def _should_summarize(total: int) -> bool:
        """轮次够多，且正好走到 4 的倍数（第 8、12、16... 轮）。"""
        return total >= MIN_TURNS and total % TRIGGER_EVERY == 0

    @staticmethod
    def _transcript(rows: list[dict]) -> str:
        """把历史轮次拼成「用户：… / 顾问：…」的纯文本。"""
        return "\n".join(
            f"用户：{r['question']}\n顾问：{(r['answer'] or '')[:ANSWER_LIMIT]}" for r in rows)

    async def _summarize(self, transcript: str) -> str | None:
        """调用 LLM 压缩对话；失败返回 None，由调用方跳过落库。"""
        try:
            summary = await self.llm.complete([
                {"role": "system", "content": SUMMARY_PROMPT},
                {"role": "user", "content": transcript[:TRANSCRIPT_LIMIT]},
            ])
        except LlmError as e:
            logger.warning("summarize failed: %s", e)
            return None
        return summary.strip()

    def history(self, conversation_id: int) -> list[dict]:
        """摘要 + 最近几轮原文，作为下一轮的对话历史。"""
        recent = self.checkpoints.history_messages(conversation_id, KEEP_RECENT)
        summary = self._load_summary(conversation_id)
        if not summary:
            return recent
        return [{"role": "system", "content": "此前对话摘要：" + summary}, *recent]

    def _load_summary(self, conversation_id: int) -> str | None:
        """读取该会话最新的摘要；没有则返回 None。"""
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
        """写入摘要；已有记录时覆盖，并更新已覆盖的快照 id。"""
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
