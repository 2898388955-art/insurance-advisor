package com.insure.advisor.product.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.common.storage.ObjectStorageService;
import com.insure.advisor.common.storage.StorageProperties;
import com.insure.advisor.product.dto.ProductImageVO;
import com.insure.advisor.product.entity.ProductImage;
import com.insure.advisor.product.mapper.ProductImageMapper;
import com.insure.advisor.product.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductImageService {

    private static final Set<String> ALLOWED_TYPES = Set.of("MAIN", "GALLERY");

    private final ProductMapper productMapper;
    private final ProductImageMapper imageMapper;
    private final ObjectStorageService storage;
    private final StorageProperties props;

    @Transactional
    public ProductImageVO upload(Long productId, MultipartFile file, String type) {
        requireProduct(productId);
        validateFile(file);
        String normalizedType = normalizeType(type);
        byte[] bytes = readBytes(file);

        // 按文件头判断真实类型，防止改扩展名绕过
        String contentType = detectContentType(bytes);
        if (contentType == null) {
            throw new BizException("仅支持 jpg / png / webp");
        }

        String key = buildObjectKey(productId, contentType);
        storage.put(key, bytes, contentType);

        ProductImage image = new ProductImage();
        image.setProductId(productId);
        image.setObjectKey(key);
        image.setType(normalizedType);
        image.setContentType(contentType);
        image.setSizeBytes(bytes.length);
        image.setSort(nextSort(productId));
        imageMapper.insert(image);

        log.info("uploaded image productId={} key={} size={}", productId, key, bytes.length);
        return toVO(image);
    }

    public List<ProductImageVO> list(Long productId) {
        return imageMapper.selectList(new LambdaQueryWrapper<ProductImage>()
                        .eq(ProductImage::getProductId, productId)
                        .orderByAsc(ProductImage::getSort)
                        .orderByAsc(ProductImage::getId))
                .stream().map(this::toVO).toList();
    }

    private void requireProduct(Long productId) {
        if (productMapper.selectById(productId) == null) {
            throw new BizException(4040, "产品不存在");
        }
    }

    /** file 来自 HTTP 边界，null/空仍属于输入校验，不是框架兜底。 */
    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BizException("文件为空");
        }
        if (file.getSize() > props.getMaxFileSize()) {
            throw new BizException("图片不能超过 5MB");
        }
    }

    private String normalizeType(String type) {
        String normalizedType = (type == null || type.isBlank()) ? "MAIN" : type.toUpperCase();
        if (!ALLOWED_TYPES.contains(normalizedType)) {
            throw new BizException("type 只能是 MAIN 或 GALLERY");
        }
        return normalizedType;
    }

    private byte[] readBytes(MultipartFile file) {
        try {
            return file.getBytes();
        } catch (IOException e) {
            throw new BizException("读取文件失败");
        }
    }

    private String buildObjectKey(Long productId, String contentType) {
        String extension = contentType.substring("image/".length());
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return "products/%d/%s.%s".formatted(productId, uuid, extension);
    }

    private int nextSort(Long productId) {
        long existing = imageMapper.selectCount(
                new LambdaQueryWrapper<ProductImage>().eq(ProductImage::getProductId, productId));
        return Math.toIntExact(existing) + 1;
    }

    private ProductImageVO toVO(ProductImage image) {
        ProductImageVO vo = new ProductImageVO();
        vo.setId(image.getId());
        vo.setType(image.getType());
        vo.setSort(image.getSort());
        vo.setUrl(storage.presignGet(image.getObjectKey()).toString());
        return vo;
    }

    private String detectContentType(byte[] b) {
        if (b.length < 12) {
            return null;
        }
        if ((b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8 && (b[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }
        if ((b[0] & 0xFF) == 0x89 && b[1] == 'P' && b[2] == 'N' && b[3] == 'G') {
            return "image/png";
        }
        if (b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F'
                && b[8] == 'W' && b[9] == 'E' && b[10] == 'B' && b[11] == 'P') {
            return "image/webp";
        }
        return null;
    }
}
