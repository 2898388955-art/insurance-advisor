-- 来源：外部抽取 Agent 产物，经审核后收纳
-- V4__field_extraction_trace.sql
-- 为「条款字段抽取」补充溯源能力。现行 V1 + V3 的 product 表有三个与规范冲突的点：
--   1) 没有 verified_from 列，无法区分「条款原文抽取」与「营销页/人工录入」
--   2) guaranteed_renewal 是 NOT NULL DEFAULT 0，无法表达铁律 6 要求的 null（未提及）
--   3) 没有任何地方存 page / quote，规范要求每个非 null 字段都可回溯到条款页码
-- 本迁移只加列与加表，不改既有数据；由 field_updates.sql 写入。
SET NAMES utf8mb4;

ALTER TABLE product
    ADD COLUMN verified_from       VARCHAR(32)  NULL COMMENT 'clause_pdf / manual / marketing_page',
    ADD COLUMN field_confidence    DECIMAL(3,2) NULL COMMENT '该批抽取的 confidence',
    ADD COLUMN field_extracted_at  DATETIME     NULL,
    MODIFY COLUMN guaranteed_renewal TINYINT(1) NULL COMMENT '是否保证续保；NULL=条款未提及（铁律6三态）';

CREATE TABLE IF NOT EXISTS product_field_quote (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    external_id    VARCHAR(32)  NOT NULL COMMENT '源产品ID，与 product.external_id 对应',
    product_id     BIGINT UNSIGNED NULL COMMENT '可空：导入顺序不同期时按 external_id 回填',
    field_name     VARCHAR(40)  NOT NULL COMMENT 'entry_age / waiting_days / exclusions ...',
    ref_seq        SMALLINT     NOT NULL DEFAULT 1 COMMENT '同一字段的第几条引用（免责要点多条）',
    field_value    VARCHAR(255) NULL,
    page_no        SMALLINT     NOT NULL COMMENT '<!-- page N of M --> 中的 N',
    quote_text     VARCHAR(120) NOT NULL COMMENT '条款原文逐字摘录（<=60 汉字）',
    parser         VARCHAR(24)  NOT NULL COMMENT 'mineru / pymupdf_fallback / docx_nopagination',
    confidence     DECIMAL(3,2) NULL,
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_ext_field_seq (external_id, field_name, ref_seq),
    KEY idx_external (external_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '字段级条款原文引用（答案溯源用）';
