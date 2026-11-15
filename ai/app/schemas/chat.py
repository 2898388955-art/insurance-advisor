"""对话相关的请求/响应模型。"""
from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, Field


class ChatMessage(BaseModel):
    role: Literal["user", "assistant", "system"]
    content: str = Field(min_length=1, max_length=4000)


class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=2000)
    conversation_id: int | None = None
    product_id: int | None = None
    history: list[ChatMessage] = Field(default_factory=list, max_length=20)


class Citation(BaseModel):
    index: int
    chunk_id: int
    parent_id: int
    product_id: int
    heading_path: str
    page_no: int
    snippet: str


class ChatResponse(BaseModel):
    answer: str
    intent: str
    citations: list[Citation] = Field(default_factory=list)
    trace_id: str
    disclaimer: str
