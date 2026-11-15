"""AI 服务入口。"""
from __future__ import annotations

import logging

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.api.routes_chat import router as chat_router

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
)

app = FastAPI(title="Insurance Advisor AI", version="0.1.0")
app.include_router(chat_router)


@app.exception_handler(Exception)
async def unhandled(request: Request, exc: Exception) -> JSONResponse:
    logging.exception("unhandled error path=%s", request.url.path)
    return JSONResponse(status_code=500, content={"code": 5000, "message": "服务内部错误"})


@app.get("/health")
async def health() -> dict:
    return {"status": "UP", "service": "insurance-ai"}
