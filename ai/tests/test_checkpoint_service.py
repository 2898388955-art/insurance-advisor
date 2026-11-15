import json

import pytest

from app.services import checkpoint_service as cs


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

    def fetchall(self):
        return self.conn.fetchall_value


class FakeConnection:
    def __init__(self):
        self.executed = []
        self.committed = False
        self.closed = False
        self.fetchone_value = None
        self.fetchall_value = []
        self.connect_kwargs = []

    def cursor(self, *args, **kwargs):
        return FakeCursor(self)

    def commit(self):
        self.committed = True

    def close(self):
        self.closed = True


@pytest.fixture
def service(monkeypatch):
    conn = FakeConnection()

    def fake_connect(**kwargs):
        conn.connect_kwargs.append(kwargs)
        return conn

    monkeypatch.setattr(cs.pymysql, "connect", fake_connect)
    return cs.CheckpointService(), conn


def state(**overrides) -> dict:
    base = {
        "question": "等待期是多久",
        "answer": "30 日",
        "intent": "rag",
        "citations": [{"index": 1, "page_no": 3}],
        "tools": [{"name": "clause_search", "detail": "检索条款 5 条"}],
        "elapsed_ms": 248,
        "product_id": 36,
    }
    base.update(overrides)
    return base


def test_saveWritesCheckpointMessagesAndConversation(service):
    svc, conn = service

    svc.save(7, "trace-1", state())

    assert len(conn.executed) == 4
    sqls = [sql for sql, _ in conn.executed]
    assert "INSERT INTO agent_checkpoint" in sqls[0]
    assert "INSERT INTO message" in sqls[1]
    assert "INSERT INTO message" in sqls[2]
    assert "UPDATE conversation" in sqls[3]

    checkpoint = conn.executed[0][1]
    assert checkpoint[0] == 7
    assert checkpoint[1] == "trace-1"
    assert checkpoint[2] == "rag"
    assert checkpoint[3] == "等待期是多久"
    assert checkpoint[4] == "30 日"
    snapshot = json.loads(checkpoint[5])
    assert snapshot["product_id"] == 36
    assert snapshot["elapsed_ms"] == 248

    user_msg = conn.executed[1][1]
    assert user_msg == (7, "等待期是多久", "rag", "trace-1")

    assistant_msg = conn.executed[2][1]
    assert assistant_msg[1] == "30 日"
    assert json.loads(assistant_msg[4])[0]["page_no"] == 3
    assert json.loads(assistant_msg[5])[0]["name"] == "clause_search"
    assert assistant_msg[6] == 248

    assert conn.committed is True
    assert conn.closed is True


def test_saveTruncatesQuestionTo2000(service):
    svc, conn = service

    svc.save(7, "trace-1", state(question="问" * 2500))

    assert len(conn.executed[0][1][3]) == 2000
    assert len(conn.executed[1][1][1]) == 2000


def test_countReturnsInteger(service):
    svc, conn = service
    conn.fetchone_value = (3,)

    assert svc.count(7) == 3
    assert "SELECT COUNT(*)" in conn.executed[0][0]
    assert conn.closed is True


def test_olderThanRecentSlicesTail(service):
    svc, conn = service
    conn.fetchall_value = [{"id": i} for i in range(6)]

    assert svc.older_than_recent(7, keep=4) == [{"id": 0}, {"id": 1}]


def test_olderThanRecentReturnsEmptyWhenNotEnough(service):
    svc, conn = service
    conn.fetchall_value = [{"id": 1}, {"id": 2}]

    assert svc.older_than_recent(7, keep=4) == []


def test_recentReversesToChronological(service):
    svc, conn = service
    conn.fetchall_value = [{"id": 3}, {"id": 2}, {"id": 1}]

    assert [r["id"] for r in svc.recent(7, 3)] == [1, 2, 3]


def test_historyMessagesSkipsEmptyAnswer(service):
    svc, _ = service
    svc.recent = lambda cid, limit=6: [
        {"question": "问一", "answer": "答一"},
        {"question": "问二", "answer": ""},
    ]

    messages = svc.history_messages(7)

    assert messages == [
        {"role": "user", "content": "问一"},
        {"role": "assistant", "content": "答一"},
        {"role": "user", "content": "问二"},
    ]


def test_latestProductIdSkipsMalformedRows(service):
    svc, _ = service
    svc.recent = lambda cid, limit=5: [
        {"state_json": '{"product_id": 5}'},
        {"state_json": "not-json"},
        {"state_json": '{"product_id": 36}'},
    ]

    assert svc.latest_product_id(7) == 36


def test_latestProductIdReturnsNone(service):
    svc, _ = service
    svc.recent = lambda cid, limit=5: [{"state_json": '{"intent": "rag"}'}, {"state_json": None}]

    assert svc.latest_product_id(7) is None


def test_snapshotDropsNoneValues():
    snapshot = cs.CheckpointService._snapshot({"intent": "rag", "product_id": None, "elapsed_ms": 0})

    assert snapshot == {"intent": "rag", "elapsed_ms": 0}
