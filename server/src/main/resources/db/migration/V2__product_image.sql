-- 产品图片：文件本体在对象存储，表里只存 object key
CREATE TABLE IF NOT EXISTS product_image (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id   BIGINT UNSIGNED NOT NULL,
    object_key   VARCHAR(500)    NOT NULL COMMENT '对象存储中的 key',
    type         VARCHAR(20)     NOT NULL DEFAULT 'MAIN' COMMENT 'MAIN 主图 / GALLERY 图集',
    content_type VARCHAR(50)     NOT NULL,
    size_bytes   INT             NOT NULL DEFAULT 0,
    sort         INT             NOT NULL DEFAULT 0,
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_product (product_id, type, sort)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '产品图片元数据';
