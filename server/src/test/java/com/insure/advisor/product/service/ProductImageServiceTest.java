package com.insure.advisor.product.service;

import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.common.storage.ObjectStorageService;
import com.insure.advisor.common.storage.StorageProperties;
import com.insure.advisor.product.dto.ProductImageVO;
import com.insure.advisor.product.entity.Product;
import com.insure.advisor.product.entity.ProductImage;
import com.insure.advisor.product.mapper.ProductImageMapper;
import com.insure.advisor.product.mapper.ProductMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;

import java.net.URL;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProductImageServiceTest {

    private static final byte[] PNG = {
            (byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 13
    };

    @Mock
    private ProductMapper productMapper;

    @Mock
    private ProductImageMapper imageMapper;

    @Mock
    private ObjectStorageService storage;

    private StorageProperties props;
    private ProductImageService service;

    @BeforeEach
    void setUp() {
        props = new StorageProperties();
        props.setMaxFileSize(1024);
        service = new ProductImageService(productMapper, imageMapper, storage, props);
    }

    private Product existingProduct() {
        Product p = new Product();
        p.setId(1L);
        return p;
    }

    private MockMultipartFile pngFile() {
        return new MockMultipartFile("file", "a.png", "image/png", PNG);
    }

    @Test
    void uploadStoresObjectAndReturnsPresignedUrl() throws Exception {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());
        when(imageMapper.selectCount(any())).thenReturn(2L);
        when(storage.presignGet(anyString())).thenReturn(new URL("http://oss/a.png"));

        ProductImageVO vo = service.upload(1L, pngFile(), "MAIN");

        ArgumentCaptor<String> key = ArgumentCaptor.forClass(String.class);
        verify(storage).put(key.capture(), eq(PNG), eq("image/png"));
        assertThat(key.getValue()).startsWith("products/1/").endsWith(".png");
        assertThat(vo.getUrl()).isEqualTo("http://oss/a.png");
        assertThat(vo.getType()).isEqualTo("MAIN");
        assertThat(vo.getSort()).isEqualTo(3);
    }

    @Test
    void uploadNormalizesBlankAndLowercaseType() throws Exception {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());
        when(imageMapper.selectCount(any())).thenReturn(0L);
        when(storage.presignGet(anyString())).thenReturn(new URL("http://oss/a.png"));

        service.upload(1L, pngFile(), null);
        service.upload(1L, pngFile(), "gallery");

        ArgumentCaptor<ProductImage> captor = ArgumentCaptor.forClass(ProductImage.class);
        verify(imageMapper, org.mockito.Mockito.times(2)).insert(captor.capture());
        assertThat(captor.getAllValues()).extracting(ProductImage::getType)
                .containsExactly("MAIN", "GALLERY");
    }

    @Test
    void uploadRejectsMissingProduct() {
        when(productMapper.selectById(9L)).thenReturn(null);

        assertThatThrownBy(() -> service.upload(9L, pngFile(), "MAIN"))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("产品不存在");
        verify(storage, never()).put(anyString(), any(byte[].class), anyString());
    }

    @Test
    void uploadRejectsEmptyFile() {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());
        MockMultipartFile empty = new MockMultipartFile("file", "a.png", "image/png", new byte[0]);

        assertThatThrownBy(() -> service.upload(1L, empty, "MAIN"))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("文件为空");
    }

    @Test
    void uploadRejectsOversizedFile() {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());
        props.setMaxFileSize(4);
        MockMultipartFile big = new MockMultipartFile("file", "a.png", "image/png", PNG);

        assertThatThrownBy(() -> service.upload(1L, big, "MAIN"))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("图片不能超过");
    }

    @Test
    void uploadRejectsUnsupportedContent() {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());
        MockMultipartFile text = new MockMultipartFile(
                "file", "a.txt", "text/plain", "hello world, not an image".getBytes());

        assertThatThrownBy(() -> service.upload(1L, text, "MAIN"))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("仅支持");
    }

    @Test
    void uploadRejectsUnknownType() {
        when(productMapper.selectById(1L)).thenReturn(existingProduct());

        assertThatThrownBy(() -> service.upload(1L, pngFile(), "COVER"))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("type 只能是");
    }

    @Test
    void listMapsPresignedUrl() throws Exception {
        ProductImage image = new ProductImage();
        image.setId(7L);
        image.setType("MAIN");
        image.setSort(1);
        image.setObjectKey("products/1/a.png");
        when(imageMapper.selectList(any())).thenReturn(List.of(image));
        when(storage.presignGet("products/1/a.png")).thenReturn(new URL("http://oss/a.png"));

        List<ProductImageVO> images = service.list(1L);

        assertThat(images).hasSize(1);
        assertThat(images.get(0).getId()).isEqualTo(7L);
        assertThat(images.get(0).getUrl()).isEqualTo("http://oss/a.png");
    }
}
