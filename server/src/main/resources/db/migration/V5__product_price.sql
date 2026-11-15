-- 价格/费率字段：展示用 price_display，参与筛选的仅金额型费率
SET NAMES utf8mb4;

ALTER TABLE product
    ADD COLUMN price_display VARCHAR(300) NULL COMMENT '展示文案，缺失时为「产品价格未公开」',
    ADD COLUMN price_status  VARCHAR(24)  NULL COMMENT 'PUBLISHED/NO_RATE_TABLE/NOT_PUBLIC/NOT_APPLICABLE',
    ADD COLUMN price_type    VARCHAR(64)  NULL COMMENT '金额型/单位保额型/公式系数型',
    ADD COLUMN price_case    VARCHAR(300) NULL COMMENT '官方说明书中的投保示例',
    ADD COLUMN rate_doc_path VARCHAR(300) NULL COMMENT '费率表原件路径',
    ADD COLUMN price_min     DECIMAL(12,2) NULL COMMENT '费率表数值下限（口径见 price_type）',
    ADD COLUMN price_max     DECIMAL(12,2) NULL COMMENT '费率表数值上限';
