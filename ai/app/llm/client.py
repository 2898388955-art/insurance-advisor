"""LLM 客户端：兼容 Ollama 与 OpenAI 协议。

为什么自己封装而不直接用 LangChain 的 ChatModel：
- 只需要「发消息、拿文本」这一件事，少一层抽象
- 本地 Ollama 与线上 OpenAI 兼容接口的请求体差异很小，封装在 30 行内
- 便于统一加超时、重试与 trace 日志
"""
from __future__ import annotations

import json
import logging
from collections.abc import AsyncIterator

import httpx

from app.config import settings

logger = logging.getLogger(__name__)


class LlmError(RuntimeError):
    pass


class ChatClient:
    def __init__(self) -> None:
        self.provider = settings.llm_provider
        self.model = settings.llm_model
        self.base_url = settings.llm_base_url.rstrip("/")
        self.api_key = settings.llm_api_key
        self.timeout = settings.llm_timeout

    async def complete(self, messages: list[dict], temperature: float = 0.2) -> str:
        if self.provider == "ollama":
            return await self._ollama(messages, temperature)
        return await self._openai(messages, temperature)

    async def stream(self, messages: list[dict], temperature: float = 0.2) -> AsyncIterator[str]:
        """真 token 流：OpenAI SSE / Ollama 流式，逐 token 产出。"""
        if self.provider == "ollama":
            async for token in self._ollama_stream(messages, temperature):
                yield token
            return
        headers = {"Authorization": f"Bearer {self.api_key}"} if self.api_key else {}
        payload = {"model": self.model, "messages": messages,
                   "temperature": temperature, "stream": True}
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            async with client.stream("POST", f"{self.base_url}/chat/completions",
                                     json=payload, headers=headers) as resp:
                if resp.status_code >= 400:
                    body = await resp.aread()
                    raise LlmError(f"openai {resp.status_code}: {body[:200]!r}")
                async for line in resp.aiter_lines():
                    if not line.startswith("data:"):
                        continue
                    data = line[5:].strip()
                    if data == "[DONE]":
                        break
                    try:
                        obj = json.loads(data)
                    except json.JSONDecodeError:
                        continue
                    delta = (obj.get("choices") or [{}])[0].get("delta", {}).get("content")
                    if delta:
                        yield delta

    async def _ollama(self, messages: list[dict], temperature: float) -> str:
        payload = {
            "model": self.model,
            "messages": messages,
            "stream": False,
            "options": {"temperature": temperature},
        }
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            resp = await client.post(f"{self.base_url}/api/chat", json=payload)
        if resp.status_code >= 400:
            raise LlmError(f"ollama {resp.status_code}: {resp.text[:200]}")
        return resp.json().get("message", {}).get("content", "").strip()

    async def _ollama_stream(self, messages: list[dict], temperature: float) -> AsyncIterator[str]:
        payload = {"model": self.model, "messages": messages, "stream": True,
                   "options": {"temperature": temperature}}
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            async with client.stream("POST", f"{self.base_url}/api/chat", json=payload) as resp:
                if resp.status_code >= 400:
                    body = await resp.aread()
                    raise LlmError(f"ollama {resp.status_code}: {body[:200]!r}")
                async for line in resp.aiter_lines():
                    if not line.strip():
                        continue
                    try:
                        obj = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    piece = obj.get("message", {}).get("content")
                    if piece:
                        yield piece
                    if obj.get("done"):
                        break

    async def _openai(self, messages: list[dict], temperature: float) -> str:
        headers = {"Authorization": f"Bearer {self.api_key}"} if self.api_key else {}
        payload = {"model": self.model, "messages": messages, "temperature": temperature}
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            resp = await client.post(
                f"{self.base_url}/chat/completions", json=payload, headers=headers)
        if resp.status_code >= 400:
            raise LlmError(f"openai {resp.status_code}: {resp.text[:200]}")
        return resp.json()["choices"][0]["message"]["content"].strip()
