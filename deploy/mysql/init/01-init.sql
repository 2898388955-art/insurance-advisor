-- 容器首次初始化时执行（仅在数据卷为空时运行）
-- 库与账号由 docker-compose 的 MYSQL_DATABASE / MYSQL_USER 自动创建，
-- 这里只做项目级初始化，业务表后续放在 server/src/main/resources/db/migration。

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS schema_version (
    version     VARCHAR(32)  NOT NULL PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    applied_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT IGNORE INTO schema_version (version, description)
VALUES ('0.0.1', 'project bootstrap');
