"""调用 Java 产品服务的客户端。

AI 服务不直接读产品表：筛选、分类、对比规则都归 Java 侧维护，
这里只做 HTTP 调用，避免两套业务逻辑漂移。
"""
from __future__ import annotations

import logging
from typing import Any

import httpx

from app.config import settings

logger = logging.getLogger(__name__)


class ProductServiceError(RuntimeError):
    pass


class ProductService:
    def __init__(self, base_url: str | None = None) -> None:
        self.base_url = (base_url or settings.java_base_url).rstrip("/")

    async def _get(self, path: str, params: dict[str, Any] | None = None) -> Any:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(f"{self.base_url}{path}", params=params)
        return self._unwrap(resp)

    async def _post(self, path: str, payload: dict[str, Any]) -> Any:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.post(f"{self.base_url}{path}", json=payload)
        return self._unwrap(resp)

    def _unwrap(self, resp: httpx.Response) -> Any:
        if resp.status_code >= 400:
            raise ProductServiceError(f"java service {resp.status_code}")
        body = resp.json()
        if body.get("code") != 0:
            raise ProductServiceError(body.get("message", "java service error"))
        return body.get("data")

    async def search(self, *, age: int | None = None, category_id: int | None = None,
                     keyword: str | None = None, size: int = 5) -> list[dict]:
        data = await self._get("/api/v1/products", {
            "age": age, "categoryId": category_id, "keyword": keyword, "size": size, "page": 1,
        })
        return data.get("records", [])

    async def detail(self, product_id: int) -> dict:
        return await self._get(f"/api/v1/products/{product_id}")

    async def compare(self, ids: list[int]) -> dict:
        return await self._post("/api/v1/products/compare", {"ids": ids})
