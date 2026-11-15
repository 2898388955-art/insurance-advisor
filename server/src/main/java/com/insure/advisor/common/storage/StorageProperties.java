package com.insure.advisor.common.storage;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "app.storage")
public class StorageProperties {

    /** S3 兼容端点，本地为 http://127.0.0.1:9000 */
    private String endpoint;

    private String accessKey;

    private String secretKey;

    private String bucket;

    private String region = "us-east-1";

    private int presignMinutes = 60;

    private long maxFileSize = 5 * 1024 * 1024;
}
