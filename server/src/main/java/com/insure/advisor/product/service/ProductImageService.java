package com.insure.advisor.product.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.common.storage.ObjectStorageService;
import com.insure.advisor.common.storage.StorageProperties;
import com.insure.advisor.product.dto.ProductImageVO;
import com.insure.advisor.product.entity.Product;
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
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new BizException(4040, "产品不存在");
        }
        if (file == null || file.isEmpty()) {
            throw new BizException("文件为空");
        }
        if (file.getSize() > props.getMaxFileSize()) {
            throw new BizException("图片不能超过 5MB");
        }
        String normalizedType = (type == null || type.isBlank()) ? "MAIN" : type.toUpperCase();
        if (!ALLOWED_TYPES.contains(normalizedType)) {
            throw new BizException("type 只能是 MAIN 或 GALLERY");
        }

        byte[] bytes;
        try {
            bytes = file.getBytes();
        } catch (IOException e) {
            throw new BizException("读取文件失败");
        }
        // 校验文件头，防止改扩展名绕过
        String contentType = detectContentType(bytes);
        if (contentType == null) {
            throw new BizException("仅支持 jpg / png / webp");
        }

        String key = "products/%d/%s.%s".formatted(productId, UUID.randomUUID().toString().replace("-", ""),
                contentType.substring("image/".length()));
        storage.put(key, bytes, contentType);

        ProductImage image = new ProductImage();
        image.setProductId(productId);
        image.setObjectKey(key);
        image.setType(normalizedType);
        image.setContentType(contentType);
        image.setSizeBytes(bytes.length);
        Long existing = imageMapper.selectCount(
                new LambdaQueryWrapper<ProductImage>().eq(ProductImage::getProductId, productId));
        image.setSort(Math.toIntExact(existing == null ? 0L : existing) + 1);
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
