"""Embedding 客户端：通过 Ollama 调本地 bge-m3。

为什么走 Ollama 而不是 sentence-transformers：
- 模型已经存在本地，无需再下一份权重
- 常驻进程，避免每次脚本启动都加载 1.2GB 模型
- HTTP 接口方便和 Java 侧共用
"""
from __future__ import annotations

import time

import httpx

OLLAMA_URL = "http://127.0.0.1:11434"
MODEL = "bge-m3"
DIM = 1024


class OllamaEmbedder:
    def __init__(self, model: str = MODEL, base_url: str = OLLAMA_URL, batch_size: int = 16):
        self.model = model
        self.base_url = base_url.rstrip("/")
        self.batch_size = batch_size

    def embed(self, texts: list[str]) -> list[list[float]]:
        if not texts:
            return []
        out: list[list[float]] = []
        with httpx.Client(timeout=180) as client:
            for i in range(0, len(texts), self.batch_size):
                batch = texts[i:i + self.batch_size]
                last_error: Exception | None = None
                for attempt in range(3):
                    try:
                        resp = client.post(
                            f"{self.base_url}/api/embed",
                            json={"model": self.model, "input": batch},
                        )
                        if resp.status_code >= 500:
                            raise RuntimeError(f"ollama {resp.status_code}: {resp.text[:200]}")
                        resp.raise_for_status()
                        out.extend(resp.json()["embeddings"])
                        last_error = None
                        break
                    except Exception as e:      # 模型加载/显存抖动时重试
                        last_error = e
                        time.sleep(2 * (attempt + 1))
                if last_error is not None:
                    raise last_error
        return out

    def embed_one(self, text: str) -> list[float]:
        return self.embed([text])[0]
