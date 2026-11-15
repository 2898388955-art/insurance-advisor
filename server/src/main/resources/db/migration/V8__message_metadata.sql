-- 消息级元数据：引用与工具调用，用于历史会话的右栏展示
SET NAMES utf8mb4;

ALTER TABLE message
    ADD COLUMN citations_json JSON NULL COMMENT '回答引用的条款片段',
    ADD COLUMN tools_json     JSON NULL COMMENT '本轮工具调用摘要',
    ADD COLUMN elapsed_ms     INT  NULL COMMENT '准备阶段耗时';
