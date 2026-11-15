package com.insure.advisor.common.storage;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

import java.net.URL;
import java.time.Duration;

@Slf4j
@Service
@RequiredArgsConstructor
public class ObjectStorageService {

    private final S3Client s3;
    private final S3Presigner presigner;
    private final StorageProperties props;

    @PostConstruct
    void init() {
        try {
            s3.headBucket(HeadBucketRequest.builder().bucket(props.getBucket()).build());
        } catch (S3Exception e) {
            if (e.statusCode() == 404) {
                s3.createBucket(b -> b.bucket(props.getBucket()));
                log.info("created bucket {}", props.getBucket());
            } else {
                log.warn("object storage not ready: {}", e.getMessage());
            }
        }
    }

    public void put(String key, byte[] bytes, String contentType) {
        s3.putObject(
                PutObjectRequest.builder()
                        .bucket(props.getBucket())
                        .key(key)
                        .contentType(contentType)
                        .build(),
                RequestBody.fromBytes(bytes));
    }

    /**
     * 返回预签名 URL：bucket 不需要公开读，链接到期自动失效。
     * 生产环境建议改为 CDN 私有回源，避免每次访问都走签名。
     */
    public URL presignGet(String key) {
        GetObjectRequest get = GetObjectRequest.builder()
                .bucket(props.getBucket())
                .key(key)
                .build();
        GetObjectPresignRequest req = GetObjectPresignRequest.builder()
                .signatureDuration(Duration.ofMinutes(props.getPresignMinutes()))
                .getObjectRequest(get)
                .build();
        return presigner.presignGetObject(req).url();
    }

    public void delete(String key) {
        s3.deleteObject(DeleteObjectRequest.builder()
                .bucket(props.getBucket())
                .key(key)
                .build());
    }
}
