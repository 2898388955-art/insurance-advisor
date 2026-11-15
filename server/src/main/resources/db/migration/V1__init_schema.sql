-- =============================================================
-- V1 初始 Schema
-- 字符集统一 utf8mb4；所有时间字段由应用或默认值维护
-- =============================================================

-- ---------- 保险类别 ----------
CREATE TABLE IF NOT EXISTS category (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id   BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 表示一级分类',
    code        VARCHAR(50)     NOT NULL COMMENT '稳定编码，如 MEDICAL',
    name        VARCHAR(50)     NOT NULL,
    level       TINYINT         NOT NULL DEFAULT 1,
    sort        INT             NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_code (code),
    KEY idx_parent (parent_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '保险分类树';

-- ---------- 产品 ----------
CREATE TABLE IF NOT EXISTS product (
    id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id        BIGINT UNSIGNED NOT NULL,
    name               VARCHAR(120)    NOT NULL,
    company            VARCHAR(120)    NOT NULL,
    code               VARCHAR(64)     NOT NULL COMMENT '产品编号',
    min_age            TINYINT UNSIGNED NOT NULL DEFAULT 0,
    max_age            TINYINT UNSIGNED NOT NULL DEFAULT 60,
    min_premium        DECIMAL(10, 2)  NULL COMMENT '年缴保费下限',
    max_premium        DECIMAL(10, 2)  NULL,
    period_desc        VARCHAR(100)    NULL COMMENT '保障期间描述，如 1年/保至70岁',
    waiting_days       SMALLINT        NULL COMMENT '等待期天数',
    guaranteed_renewal TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否保证续保',
    highlights         VARCHAR(500)    NULL COMMENT '卖点摘要，供列表页与 LLM 参考',
    status             TINYINT         NOT NULL DEFAULT 1 COMMENT '1 上架 0 下架',
    created_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_code (code),
    KEY idx_category_status (category_id, status),
    KEY idx_premium (min_premium, max_premium)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '保险产品';

-- ---------- 条款文档 ----------
CREATE TABLE IF NOT EXISTS product_clause (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id     BIGINT UNSIGNED NOT NULL,
    doc_id         VARCHAR(64)     NOT NULL COMMENT '文档唯一标识，由文件哈希派生',
    version        VARCHAR(32)     NOT NULL DEFAULT 'v1',
    effective_date DATE            NULL,
    file_path      VARCHAR(500)    NOT NULL COMMENT '原始 PDF 路径',
    file_hash      CHAR(64)        NOT NULL COMMENT 'sha256，用于幂等',
    page_count     INT             NULL,
    status         VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                   COMMENT 'PENDING/PARSING/CHUNKING/INDEXING/DONE/FAILED',
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_doc_id (doc_id),
    KEY idx_product (product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '条款文档与解析状态';

-- ---------- 父块 ----------
CREATE TABLE IF NOT EXISTS clause_parent (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    doc_id       VARCHAR(64)     NOT NULL,
    product_id   BIGINT UNSIGNED NOT NULL,
    heading_path VARCHAR(500)    NOT NULL COMMENT '如 2.我们提供的保障 > 2.5 保险责任',
    content      MEDIUMTEXT      NOT NULL,
    page_from    INT             NOT NULL,
    page_to      INT             NOT NULL,
    seq          INT             NOT NULL COMMENT '文档内顺序，用于相邻块扩展',
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_doc (doc_id, seq),
    KEY idx_product (product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '条款父块（整节，用于回填上下文）';

-- ---------- 子块 ----------
CREATE TABLE IF NOT EXISTS clause_child (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id    BIGINT UNSIGNED NOT NULL,
    doc_id       VARCHAR(64)     NOT NULL,
    product_id   BIGINT UNSIGNED NOT NULL,
    heading_path VARCHAR(500)    NOT NULL,
    content      TEXT            NOT NULL,
    token_cnt    SMALLINT        NOT NULL DEFAULT 0,
    page_no      INT             NOT NULL,
    vector_id    VARCHAR(64)     NULL COMMENT 'Milvus 主键',
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_parent (parent_id),
    KEY idx_doc (doc_id),
    KEY idx_product (product_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '条款子块（用于向量召回）';

-- ---------- 会话 ----------
CREATE TABLE IF NOT EXISTS conversation (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id     BIGINT UNSIGNED NOT NULL DEFAULT 0,
    title       VARCHAR(200)    NULL COMMENT '首条用户消息截断',
    last_intent VARCHAR(32)     NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_user_updated (user_id, updated_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '对话会话';

-- ---------- 消息 ----------
CREATE TABLE IF NOT EXISTS message (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id BIGINT UNSIGNED NOT NULL,
    role            VARCHAR(16)     NOT NULL COMMENT 'user/assistant/system',
    content         MEDIUMTEXT      NOT NULL,
    intent          VARCHAR(32)     NULL,
    token_in        INT             NOT NULL DEFAULT 0,
    token_out       INT             NOT NULL DEFAULT 0,
    latency_ms      INT             NOT NULL DEFAULT 0,
    trace_id        VARCHAR(64)     NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_conversation (conversation_id, id),
    KEY idx_trace (trace_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '对话消息';

-- ---------- 引用 ----------
CREATE TABLE IF NOT EXISTS message_citation (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    message_id BIGINT UNSIGNED NOT NULL,
    chunk_id   BIGINT UNSIGNED NOT NULL,
    parent_id  BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    score      FLOAT           NOT NULL DEFAULT 0,
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_message (message_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '回答引用的条款片段';

-- ---------- 入库任务 ----------
CREATE TABLE IF NOT EXISTS ingest_task (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    doc_id      VARCHAR(64)     NOT NULL,
    product_id  BIGINT UNSIGNED NOT NULL,
    status      VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    step        VARCHAR(32)     NULL COMMENT '当前阶段，便于前端展示进度',
    err_msg     VARCHAR(1000)   NULL,
    started_at  DATETIME        NULL,
    finished_at DATETIME        NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_doc (doc_id),
    KEY idx_status (status)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '条款解析入库任务';

-- ---------- LLM 调用日志 ----------
CREATE TABLE IF NOT EXISTS llm_call_log (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    trace_id         VARCHAR(64)     NOT NULL,
    scene            VARCHAR(32)     NOT NULL COMMENT 'router/rag/recommend/compliance',
    model            VARCHAR(64)     NOT NULL,
    prompt_tokens    INT             NOT NULL DEFAULT 0,
    completion_tokens INT            NOT NULL DEFAULT 0,
    cost             DECIMAL(10, 6)  NOT NULL DEFAULT 0 COMMENT '人民币元',
    latency_ms       INT             NOT NULL DEFAULT 0,
    created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_trace (trace_id),
    KEY idx_created (created_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'LLM 调用成本与延迟埋点';
