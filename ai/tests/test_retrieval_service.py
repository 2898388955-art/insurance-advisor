import asyncio

import pytest

from app.config import settings
from app.services import retrieval_service as rs
from app.services.retrieval_service import RetrievalService, build_context


def entity(parent_id: int, text: str = "子块正文") -> dict:
    return {
        "doc_id": "doc-1",
        "product_id": 36,
        "parent_id": parent_id,
        "heading_path": f"2. 保障 > 2.{parent_id} 条",
        "page_no": 3,
        "text": text,
    }


class FakeClient:
    def __init__(self, dense=None, sparse=None):
        self.dense = dense or []
        self.sparse = sparse or []
        self.calls = []

    def search(self, collection, data, anns_field, limit, filter, output_fields, search_params):
        self.calls.append({
            "anns_field": anns_field, "limit": limit,
            "filter": filter, "metric": search_params["metric_type"],
        })
        hits = self.dense if anns_field == "embedding" else self.sparse
        return [hits]


class FakeEmbedder:
    def embed_one(self, text):
        return [0.1, 0.2, 0.3]


@pytest.fixture
def service(monkeypatch):
    client = FakeClient()
    monkeypatch.setattr(rs, "get_client", lambda: client)
    monkeypatch.setattr(rs, "OllamaEmbedder", FakeEmbedder)
    svc = RetrievalService()
    svc.fake_client = client
    return svc


def test_dense_only_maps_hits(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 1.0)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.0)
    service.fake_client.dense = [
        {"id": 11, "entity": entity(10)},
        {"id": 12, "entity": entity(10)},
    ]

    hits = service._search("等待期", [0.1], top_k=2, expr="product_id == 36")

    assert [h["chunk_id"] for h in hits] == [11, 12]
    assert hits[0]["doc_id"] == "doc-1"
    assert hits[0]["page_no"] == 3
    only = service.fake_client.calls
    assert len(only) == 1
    assert only[0]["anns_field"] == "embedding"
    assert only[0]["filter"] == "product_id == 36"
    assert only[0]["limit"] == max(2 * 4, settings.retrieval_candidates)


def test_sparse_skipped_when_weight_zero(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 1.0)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.0)

    service._search("等待期", [0.1], top_k=2, expr=None)

    assert [c["anns_field"] for c in service.fake_client.calls] == ["embedding"]


def test_hybrid_fuses_both_rankings(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 0.5)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.5)
    service.fake_client.dense = [{"id": 1, "entity": entity(10)}, {"id": 2, "entity": entity(11)}]
    service.fake_client.sparse = [{"id": 2, "entity": entity(11)}, {"id": 3, "entity": entity(12)}]

    hits = service._search("等待期", [0.1], top_k=3, expr=None)

    assert [h["chunk_id"] for h in hits] == [2, 1, 3]


def test_retrieve_adds_parent_content(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 1.0)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.0)
    service.fake_client.dense = [{"id": 11, "entity": entity(10)}]
    service._load_parents = lambda ids: {10: "完整父块"}

    hits = asyncio.run(service.retrieve("等待期是多久", product_id=36))

    assert hits[0]["parent_content"] == "完整父块"


def test_retrieve_falls_back_to_child_text(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 1.0)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.0)
    service.fake_client.dense = [{"id": 11, "entity": entity(10, "子块原文")}]
    service._load_parents = lambda ids: {}

    hits = asyncio.run(service.retrieve("等待期是多久"))

    assert hits[0]["parent_content"] == "子块原文"


def test_retrieve_returns_empty_without_hits(monkeypatch, service):
    monkeypatch.setattr(settings, "retrieval_dense_weight", 1.0)
    monkeypatch.setattr(settings, "retrieval_sparse_weight", 0.0)

    assert asyncio.run(service.retrieve("无关问题")) == []


def test_build_context_numbers_sections():
    context = build_context([
        {"heading_path": "2.3 等待期", "page_no": 3, "parent_content": "等待期 30 日"},
        {"heading_path": "2.4 免赔额", "page_no": 3, "parent_content": "500 元"},
    ])

    assert context.startswith("[1] 2.3 等待期（第 3 页）\n等待期 30 日")
    assert "[2] 2.4 免赔额（第 3 页）\n500 元" in context
