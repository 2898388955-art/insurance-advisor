import asyncio

import pytest

from app.llm.client import LlmError
from app.services import summary_service as ss
from app.services.summary_service import SummaryService


class FakeCheckpoints:
    def __init__(self):
        self.count_value = 0
        self.older_rows = []
        self.recent_rows = []
        self.history_rows = None
        self.calls = []

    def count(self, conversation_id):
        self.calls.append(("count", conversation_id))
        return self.count_value

    def older_than_recent(self, conversation_id, keep):
        self.calls.append(("older", conversation_id, keep))
        return self.older_rows

    def recent(self, conversation_id, limit):
        self.calls.append(("recent", conversation_id, limit))
        return self.recent_rows

    def history_messages(self, conversation_id, limit):
        self.calls.append(("history_messages", conversation_id, limit))
        if self.history_rows is not None:
            return list(self.history_rows)
        messages = []
        for row in self.recent_rows:
            messages.append({"role": "user", "content": row["question"]})
            if row.get("answer"):
                messages.append({"role": "assistant", "content": row["answer"]})
        return messages


class FakeLlm:
    def __init__(self, result="摘要", error=None):
        self.result = result
        self.error = error
        self.messages = None

    async def complete(self, messages):
        self.messages = messages
        if self.error:
            raise self.error
        return self.result


class FakeCursor:
    def __init__(self, conn):
        self.conn = conn

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def execute(self, sql, params=None):
        self.conn.executed.append((sql, params))

    def fetchone(self):
        return self.conn.fetchone_value


class FakeConnection:
    def __init__(self):
        self.executed = []
        self.fetchone_value = None
        self.committed = False
        self.closed = False

    def cursor(self):
        return FakeCursor(self)

    def commit(self):
        self.committed = True

    def close(self):
        self.closed = True


@pytest.fixture
def parts():
    checkpoints = FakeCheckpoints()
    llm = FakeLlm()
    service = SummaryService(checkpoints, llm)
    return service, checkpoints, llm


def test_skips_below_min_turns(parts):
    service, checkpoints, llm = parts
    checkpoints.count_value = 5
    upserts = []
    service._upsert = lambda *args: upserts.append(args)

    asyncio.run(service.maybe_summarize(7))

    assert ("older", 7, 4) not in checkpoints.calls
    assert llm.messages is None
    assert upserts == []


def test_skips_when_not_trigger_interval(parts):
    service, checkpoints, llm = parts
    checkpoints.count_value = 6

    asyncio.run(service.maybe_summarize(7))

    assert llm.messages is None


def test_summarizes_and_upserts_newest_covered_id(parts):
    service, checkpoints, llm = parts
    checkpoints.count_value = 8
    checkpoints.older_rows = [
        {"id": 1, "question": "问一", "answer": "答一" * 500},
        {"id": 2, "question": "问二", "answer": "答二"},
    ]
    llm.result = "  压缩后的摘要  "
    upserts = []
    service._upsert = lambda cid, summary, covered: upserts.append((cid, summary, covered))

    asyncio.run(service.maybe_summarize(7))

    assert llm.messages[0]["role"] == "system"
    assert ss.SUMMARY_PROMPT in llm.messages[0]["content"]
    transcript = llm.messages[1]["content"]
    assert "用户：问一" in transcript
    assert "答二" in transcript
    assert len(transcript) <= 6000
    assert upserts == [(7, "压缩后的摘要", 2)]


def test_llm_error_skips_upsert(parts):
    service, checkpoints, _ = parts
    checkpoints.count_value = 8
    checkpoints.older_rows = [{"id": 1, "question": "问", "answer": "答"}]
    service.llm = FakeLlm(error=LlmError("boom"))
    upserts = []
    service._upsert = lambda *args: upserts.append(args)

    asyncio.run(service.maybe_summarize(7))

    assert upserts == []


def test_history_prepends_summary_and_keeps_recent_turns(parts):
    service, checkpoints, _ = parts
    service._load_summary = lambda cid: "旧摘要"
    checkpoints.recent_rows = [
        {"question": "问一", "answer": "答一"},
        {"question": "问二", "answer": ""},
    ]

    messages = service.history(7)

    assert messages[0] == {"role": "system", "content": "此前对话摘要：旧摘要"}
    assert messages[1:] == [
        {"role": "user", "content": "问一"},
        {"role": "assistant", "content": "答一"},
        {"role": "user", "content": "问二"},
    ]


def test_history_without_summary(parts):
    service, checkpoints, _ = parts
    service._load_summary = lambda cid: None
    checkpoints.recent_rows = [{"question": "问", "answer": "答"}]

    assert service.history(7) == [
        {"role": "user", "content": "问"},
        {"role": "assistant", "content": "答"},
    ]


def test_history_reuses_checkpoint_message_assembly(parts):
    """最近轮次的消息拼装交给 CheckpointService，只在这里拼接摘要。"""
    service, checkpoints, _ = parts
    service._load_summary = lambda cid: None
    checkpoints.history_rows = [{"role": "user", "content": "由 CheckpointService 拼装"}]

    assert service.history(7) == [{"role": "user", "content": "由 CheckpointService 拼装"}]
    assert ("history_messages", 7, 4) in checkpoints.calls


def test_load_summary_returns_value(monkeypatch):
    conn = FakeConnection()
    conn.fetchone_value = ("已有摘要",)
    monkeypatch.setattr(ss.pymysql, "connect", lambda **kwargs: conn)

    assert SummaryService(FakeCheckpoints(), FakeLlm())._load_summary(7) == "已有摘要"
    assert conn.closed is True


def test_load_summary_returns_none(monkeypatch):
    conn = FakeConnection()
    monkeypatch.setattr(ss.pymysql, "connect", lambda **kwargs: conn)

    assert SummaryService(FakeCheckpoints(), FakeLlm())._load_summary(7) is None


def test_upsert_writes_and_commits(monkeypatch):
    conn = FakeConnection()
    monkeypatch.setattr(ss.pymysql, "connect", lambda **kwargs: conn)
    service = SummaryService(FakeCheckpoints(), FakeLlm())

    service._upsert(7, "摘要", 12)

    sql, params = conn.executed[0]
    assert "INSERT INTO conversation_summary" in sql
    assert params == (7, "摘要", 12)
    assert conn.committed is True
    assert conn.closed is True
