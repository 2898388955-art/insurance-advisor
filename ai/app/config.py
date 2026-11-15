import os
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict

ROOT = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=str(ROOT / "deploy" / ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    mysql_host: str = "127.0.0.1"
    mysql_port: int = 3307
    mysql_user: str = "ia"
    mysql_password: str = ""
    mysql_database: str = "insurance_advisor"

    redis_port: int = 6380
    milvus_host: str = "127.0.0.1"
    milvus_port: int = 19530
    milvus_uri: str = ""
    ollama_url: str = "http://127.0.0.1:11434"

    # Java 业务服务
    java_base_url: str = "http://127.0.0.1:8080"

    # LLM：默认 DeepSeek（OpenAI 兼容协议）。
    # 密钥只从环境变量读取，不写入任何配置文件。
    llm_provider: str = "openai"
    llm_model: str = "deepseek-flash"
    llm_base_url: str = "https://api.deepseek.com/v1"
    llm_api_key: str = ""
    llm_timeout: float = 120.0

    retrieval_top_k: int = 5
    retrieval_candidates: int = 20
    retrieval_rrf_k: int = 60
    # 评测结论：当前语料上纯向量最优（见 docs/eval-report.md）。
    # 混合检索保留为可配置能力，扩大语料后可调整权重重新启用。
    retrieval_dense_weight: float = 1.0
    retrieval_sparse_weight: float = 0.0

    @property
    def mysql_dsn(self) -> dict:
        return dict(
            host=self.mysql_host,
            port=self.mysql_port,
            user=self.mysql_user,
            password=self.mysql_password,
            database=self.mysql_database,
            charset="utf8mb4",
        )


settings = Settings()

# 密钥优先取平台注入的环境变量；配置文件里不落盘
if not settings.llm_api_key:
    settings.llm_api_key = os.getenv("DEEPSEEK_API_KEY", "") or os.getenv("LLM_API_KEY", "")
