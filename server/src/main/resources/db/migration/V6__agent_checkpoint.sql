-- Agent 会话记忆快照：每轮对话保存完整状态，供下一轮恢复与审计
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS agent_checkpoint (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id BIGINT UNSIGNED NOT NULL,
    trace_id        VARCHAR(64)     NOT NULL,
    intent          VARCHAR(32)     NULL,
    question        VARCHAR(2000)   NOT NULL,
    answer          MEDIUMTEXT      NULL,
    state_json      JSON            NULL COMMENT '本轮完整状态快照',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_conversation (conversation_id, id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Agent 会话记忆快照';
