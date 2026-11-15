"""Milvus collection 的建表与读写。"""
from __future__ import annotations

from pymilvus import DataType, MilvusClient

from app.config import settings
from app.rag.embedder import DIM

COLLECTION = "clause_child"


def get_client() -> MilvusClient:
    return MilvusClient(uri=f"http://127.0.0.1:{settings.milvus_port}")


def ensure_collection(client: MilvusClient) -> None:
    if client.has_collection(COLLECTION):
        return
    schema = client.create_schema(auto_id=False, enable_dynamic_field=False)
    schema.add_field("id", DataType.INT64, is_primary=True)
    schema.add_field("doc_id", DataType.VARCHAR, max_length=64)
    schema.add_field("product_id", DataType.INT64)
    schema.add_field("parent_id", DataType.INT64)
    schema.add_field("heading_path", DataType.VARCHAR, max_length=2048)
    schema.add_field("page_no", DataType.INT32)
    schema.add_field("text", DataType.VARCHAR, max_length=8192)
    schema.add_field("embedding", DataType.FLOAT_VECTOR, dim=DIM)

    index_params = client.prepare_index_params()
    index_params.add_index(
        field_name="embedding",
        index_type="HNSW",
        metric_type="COSINE",
        params={"M": 16, "efConstruction": 200},
    )
    client.create_collection(COLLECTION, schema=schema, index_params=index_params)


def reset_collection(client: MilvusClient) -> None:
    if client.has_collection(COLLECTION):
        client.drop_collection(COLLECTION)
    ensure_collection(client)
