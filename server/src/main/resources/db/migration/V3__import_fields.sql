-- 适配 48 条产品公开数据导入
SET NAMES utf8mb4;

ALTER TABLE product
    ADD COLUMN external_id     VARCHAR(32)  NULL COMMENT '源数据产品ID，幂等键' AFTER id,
    ADD UNIQUE KEY uk_external_id (external_id),
    ADD COLUMN product_type    VARCHAR(64)  NULL,
    ADD COLUMN target_audience VARCHAR(200) NULL,
    ADD COLUMN payment_term    VARCHAR(100) NULL,
    ADD COLUMN coverage_term   VARCHAR(100) NULL,
    ADD COLUMN sale_status     VARCHAR(100) NULL,
    ADD COLUMN registration_no VARCHAR(100) NULL,
    ADD COLUMN issuer_type     VARCHAR(20)  NOT NULL DEFAULT 'INSURER' COMMENT 'INSURER 保险公司 / INDUSTRY_STANDARD 行业示范条款',
    ADD COLUMN data_status     VARCHAR(20)  NOT NULL DEFAULT 'PARTIAL' COMMENT 'VERIFIED 有条款原件 / NO_CLAUSE 缺条款 / LEAD 仅线索',
    ADD COLUMN source_url      VARCHAR(500) NULL,
    ADD COLUMN import_batch    VARCHAR(32)  NULL,
    MODIFY COLUMN min_age      TINYINT UNSIGNED NULL,
    MODIFY COLUMN max_age      TINYINT UNSIGNED NULL,
    MODIFY COLUMN waiting_days SMALLINT NULL,
    MODIFY COLUMN period_desc  VARCHAR(100) NULL;

ALTER TABLE product_clause
    ADD COLUMN file_type   VARCHAR(10)  NULL COMMENT 'PDF / DOCX',
    ADD COLUMN reg_no      VARCHAR(100) NULL,
    ADD COLUMN clause_name VARCHAR(200) NULL;

-- 原始导入快照：导入逻辑出错时可重放，不必重新找数据
CREATE TABLE IF NOT EXISTS product_import_raw (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    batch_id    VARCHAR(32)     NOT NULL,
    external_id VARCHAR(32)     NOT NULL,
    raw_json    JSON            NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_batch (batch_id),
    KEY idx_external (external_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '产品源数据快照';

-- 源数据里出现的补充分类
INSERT INTO category (id, parent_id, code, name, level, sort) VALUES
 (8,  0, 'PROPERTY_LIABILITY', '财产险', 1, 80),
 (81, 8, 'AUTO_INSURANCE', '机动车辆保险', 2, 81),
 (99, 0, 'UNCLASSIFIED', '待分类', 1, 99)
ON DUPLICATE KEY UPDATE name = VALUES(name);
