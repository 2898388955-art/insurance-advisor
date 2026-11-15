FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    PYTHONPATH=/app \
    PATH=/app/.venv/bin:$PATH

RUN pip install --no-cache-dir uv -i https://pypi.tuna.tsinghua.edu.cn/simple

WORKDIR /app
COPY pyproject.toml uv.lock ./
# 运行镜像不安装 mineru（ingest 可选依赖）
RUN uv sync --frozen --no-dev

COPY app ./app

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
