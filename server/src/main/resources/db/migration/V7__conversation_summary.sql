-- 长会话摘要：超过阈值后把较早轮次压缩成一段摘要
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS conversation_summary (
    conversation_id       BIGINT UNSIGNED NOT NULL,
    summary               TEXT            NOT NULL,
    covered_checkpoint_id BIGINT UNSIGNED NOT NULL,
    updated_at            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (conversation_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '会话记忆摘要';
