"""会话记忆：把每轮对话的完整状态存成快照，下一轮按会话恢复。

为什么自己实现而不直接用 LangGraph 的 checkpointer：
官方持久化后端是 SQLite/Postgres，项目统一在 MySQL；快照结构也只需要
「按会话取最近 N 轮」这一种查询，自己存更直接，且能同时保存引用与意图供审计。
"""
from __future__ import annotations

import json

import pymysql

from app.config import settings


class CheckpointService:
    def save(self, conversation_id: int, trace_id: str, state: dict) -> None:
        question = state.get("question", "")[:2000]
        answer = state.get("answer", "")
        intent = state.get("intent")

        conn = self._connect()
        try:
            with conn.cursor() as cur:
                self._insert_checkpoint(cur, conversation_id, trace_id, intent, question, answer, state)
                self._insert_messages(cur, conversation_id, trace_id, intent, question, answer, state)
                self._touch_conversation(cur, conversation_id, question, intent)
            conn.commit()
        finally:
            conn.close()

    def count(self, conversation_id: int) -> int:
        conn = self._connect()
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM agent_checkpoint WHERE conversation_id=%s",
                            (conversation_id,))
                return int(cur.fetchone()[0])
        finally:
            conn.close()

    def older_than_recent(self, conversation_id: int, keep: int = 4) -> list[dict]:
        """取除最近 keep 轮以外的历史，用于压缩摘要。"""
        rows = self._fetch_all(
            """SELECT id, question, answer FROM agent_checkpoint
               WHERE conversation_id=%s ORDER BY id ASC""",
            (conversation_id,),
        )
        return rows[:-keep] if len(rows) > keep else []

    def recent(self, conversation_id: int, limit: int = 6) -> list[dict]:
        rows = self._fetch_all(
            """SELECT intent, question, answer, state_json, created_at
               FROM agent_checkpoint WHERE conversation_id=%s
               ORDER BY id DESC LIMIT %s""",
            (conversation_id, limit),
        )
        return list(reversed(rows))

    def history_messages(self, conversation_id: int, limit: int = 6) -> list[dict]:
        messages: list[dict] = []
        for row in self.recent(conversation_id, limit):
            messages.append({"role": "user", "content": row["question"]})
            if row.get("answer"):
                messages.append({"role": "assistant", "content": row["answer"]})
        return messages

    def latest_product_id(self, conversation_id: int) -> int | None:
        """上一轮关联的产品，用于"它/这款"这类指代消解。"""
        for row in reversed(self.recent(conversation_id, 5)):
            product_id = self._product_id_of(row)
            if product_id is not None:
                return product_id
        return None

    @staticmethod
    def _connect(dict_rows: bool = False):
        if dict_rows:
            return pymysql.connect(**settings.mysql_dsn, cursorclass=pymysql.cursors.DictCursor)
        return pymysql.connect(**settings.mysql_dsn)

    def _fetch_all(self, sql: str, params: tuple) -> list[dict]:
        conn = self._connect(dict_rows=True)
        try:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                return cur.fetchall()
        finally:
            conn.close()

    @staticmethod
    def _insert_checkpoint(cur, conversation_id: int, trace_id: str, intent,
                           question: str, answer: str, state: dict) -> None:
        cur.execute(
            """INSERT INTO agent_checkpoint
               (conversation_id, trace_id, intent, question, answer, state_json)
               VALUES (%s,%s,%s,%s,%s,%s)""",
            (conversation_id, trace_id, intent, question, answer,
             json.dumps(CheckpointService._snapshot(state), ensure_ascii=False)),
        )

    @staticmethod
    def _insert_messages(cur, conversation_id: int, trace_id: str, intent,
                         question: str, answer: str, state: dict) -> None:
        """对话消息单独落库，供 Java 的历史消息接口读取。"""
        cur.execute(
            """INSERT INTO message (conversation_id, role, content, intent, trace_id)
               VALUES (%s,'user',%s,%s,%s)""",
            (conversation_id, question, intent, trace_id),
        )
        cur.execute(
            """INSERT INTO message
               (conversation_id, role, content, intent, trace_id,
                citations_json, tools_json, elapsed_ms)
               VALUES (%s,'assistant',%s,%s,%s,%s,%s,%s)""",
            (conversation_id, answer, intent, trace_id,
             json.dumps(state.get("citations") or [], ensure_ascii=False),
             json.dumps(state.get("tools") or [], ensure_ascii=False),
             state.get("elapsed_ms")),
        )

    @staticmethod
    def _touch_conversation(cur, conversation_id: int, question: str, intent) -> None:
        """首轮用它的问题做标题，并刷新活跃时间。"""
        cur.execute(
            """UPDATE conversation SET
                   title = CASE WHEN title IS NULL OR title='新对话'
                                THEN LEFT(%s, 30) ELSE title END,
                   last_intent = %s,
                   updated_at = NOW()
               WHERE id = %s""",
            (question, intent, conversation_id),
        )

    @staticmethod
    def _product_id_of(row: dict) -> int | None:
        raw = row.get("state_json")
        if not raw:
            return None
        try:
            data = json.loads(raw) if isinstance(raw, str) else raw
        except (TypeError, json.JSONDecodeError):
            return None
        product_id = data.get("product_id")
        return int(product_id) if product_id else None

    @staticmethod
    def _snapshot(state: dict) -> dict:
        """只保留可序列化且对下一轮有用的字段。"""
        keys = ("intent", "question", "answer", "citations", "tools",
                "elapsed_ms", "occupation", "product_id")
        return {k: state.get(k) for k in keys if state.get(k) is not None}
