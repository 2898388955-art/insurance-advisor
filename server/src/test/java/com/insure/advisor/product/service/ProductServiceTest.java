package com.insure.advisor.product.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.insure.advisor.category.entity.Category;
import com.insure.advisor.category.mapper.CategoryMapper;
import com.insure.advisor.clause.entity.ProductClause;
import com.insure.advisor.clause.mapper.ProductClauseMapper;
import com.insure.advisor.common.exception.BizException;
import com.insure.advisor.common.storage.ObjectStorageService;
import com.insure.advisor.common.web.PageResult;
import com.insure.advisor.product.dto.CompareVO;
import com.insure.advisor.product.dto.ProductCardVO;
import com.insure.advisor.product.dto.ProductDetailVO;
import com.insure.advisor.product.dto.ProductImageVO;
import com.insure.advisor.product.dto.ProductQuery;
import com.insure.advisor.product.entity.Product;
import com.insure.advisor.product.entity.ProductImage;
import com.insure.advisor.product.mapper.ProductImageMapper;
import com.insure.advisor.product.mapper.ProductMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.net.URL;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductMapper productMapper;
    @Mock
    private CategoryMapper categoryMapper;
    @Mock
    private ProductImageMapper imageMapper;
    @Mock
    private ProductClauseMapper clauseMapper;
    @Mock
    private ProductImageService imageService;
    @Mock
    private ObjectStorageService storage;

    private ProductService service;

    @BeforeEach
    void setUp() {
        service = new ProductService(productMapper, categoryMapper, imageMapper,
                clauseMapper, imageService, storage);
    }

    private Product product(long id, String name, Integer waitingDays, Boolean renewal) {
        Product p = new Product();
        p.setId(id);
        p.setExternalId("P" + id);
        p.setCategoryId(22L);
        p.setName(name);
        p.setCompany("测试保险");
        p.setProductType("门急诊医疗");
        p.setMinAge(0);
        p.setMaxAge(60);
        p.setMinPremium(new BigDecimal("100"));
        p.setMaxPremium(new BigDecimal("300"));
        p.setPeriodDesc("1年");
        p.setCoverageTerm("1年");
        p.setPaymentTerm("趸交");
        p.setWaitingDays(waitingDays);
        p.setGuaranteedRenewal(renewal);
        p.setHighlights("门急诊");
        p.setDataStatus("VERIFIED");
        p.setVerifiedFrom("clause_pdf");
        p.setPriceDisplay("官方费率表");
        p.setPriceStatus("PUBLISHED");
        return p;
    }

    private Category category() {
        Category c = new Category();
        c.setId(22L);
        c.setName("门急诊医疗");
        return c;
    }

    private ProductImage image(long productId) {
        ProductImage img = new ProductImage();
        img.setProductId(productId);
        img.setObjectKey("products/" + productId + "/a.png");
        img.setSort(1);
        return img;
    }

    @Test
    void searchMapsCardFieldsAndPagination() throws Exception {
        when(categoryMapper.selectList(any())).thenReturn(List.of(category()));
        Page<Product> page = new Page<>(1, 12);
        page.setRecords(List.of(product(1, "门急诊 D 款", 30, false)));
        page.setTotal(1);
        when(productMapper.selectPage(any(), any())).thenReturn(page);
        when(imageMapper.selectList(any())).thenReturn(List.of(image(1)));
        when(storage.presignGet("products/1/a.png")).thenReturn(new URL("http://oss/1.png"));

        PageResult<ProductCardVO> result = service.search(new ProductQuery());

        assertThat(result.getTotal()).isEqualTo(1);
        assertThat(result.getRecords()).hasSize(1);
        ProductCardVO card = result.getRecords().get(0);
        assertThat(card.getName()).isEqualTo("门急诊 D 款");
        assertThat(card.getCategoryName()).isEqualTo("门急诊医疗");
        assertThat(card.getCoverImageUrl()).isEqualTo("http://oss/1.png");
        assertThat(card.getPriceDisplay()).isEqualTo("官方费率表");
        assertThat(card.getLabels()).containsExactly("等待期 30 天", "不保证续保", "条款原文抽取");
    }

    @Test
    void searchFallsBackToUnknownPrice() {
        when(categoryMapper.selectList(any())).thenReturn(List.of(category()));
        Product p = product(1, "门急诊 D 款", null, null);
        p.setPriceDisplay(null);
        p.setPriceStatus("NOT_PUBLIC");
        Page<Product> page = new Page<>(1, 12);
        page.setRecords(List.of(p));
        page.setTotal(1);
        when(productMapper.selectPage(any(), any())).thenReturn(page);
        when(imageMapper.selectList(any())).thenReturn(List.of());

        ProductCardVO card = service.search(new ProductQuery()).getRecords().get(0);

        assertThat(card.getPriceDisplay()).isEqualTo("产品价格未公开");
        assertThat(card.getLabels()).contains("价格未公开");
    }

    @Test
    void detailCopiesCardFieldsAndListsClauses() throws Exception {
        when(productMapper.selectById(1L)).thenReturn(product(1, "门急诊 D 款", 30, false));
        when(categoryMapper.selectList(any())).thenReturn(List.of(category()));
        when(imageMapper.selectList(any())).thenReturn(List.of(image(1)));
        when(storage.presignGet("products/1/a.png")).thenReturn(new URL("http://oss/1.png"));

        ProductClause clause = new ProductClause();
        clause.setDocId("doc-1");
        clause.setClauseName("条款名称");
        clause.setFileType("PDF");
        clause.setPageCount(11);
        clause.setStatus("DONE");
        clause.setRegNo("备案号");
        when(clauseMapper.selectList(any())).thenReturn(List.of(clause));

        ProductImageVO imageVO = new ProductImageVO();
        imageVO.setId(9L);
        imageVO.setUrl("http://oss/1.png");
        when(imageService.list(1L)).thenReturn(List.of(imageVO));

        ProductDetailVO detail = service.detail(1L);

        assertThat(detail.getId()).isEqualTo(1L);
        assertThat(detail.getName()).isEqualTo("门急诊 D 款");
        assertThat(detail.getCategoryName()).isEqualTo("门急诊医疗");
        assertThat(detail.getCoverImageUrl()).isEqualTo("http://oss/1.png");
        assertThat(detail.getPaymentTerm()).isEqualTo("趸交");
        assertThat(detail.getLabels()).contains("等待期 30 天", "不保证续保", "条款原文抽取");
        assertThat(detail.getClauses()).hasSize(1);
        assertThat(detail.getClauses().get(0).getDocId()).isEqualTo("doc-1");
        assertThat(detail.getImages()).hasSize(1);
    }

    @Test
    void detailMissingProductThrows() {
        when(productMapper.selectById(2L)).thenReturn(null);

        assertThatThrownBy(() -> service.detail(2L))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("产品不存在");
    }

    @Test
    void compareBuildsRowsInRequestedOrder() {
        Product first = product(1, "产品一", 30, false);
        Product second = product(2, "产品二", 90, true);
        when(productMapper.selectBatchIds(List.of(2L, 1L))).thenReturn(List.of(first, second));
        when(categoryMapper.selectList(any())).thenReturn(List.of(category()));
        when(imageMapper.selectList(any())).thenReturn(List.of());

        CompareVO vo = service.compare(List.of(2L, 1L));

        assertThat(vo.getProducts()).extracting(ProductCardVO::getId).containsExactly(2L, 1L);
        assertThat(vo.getRows()).hasSize(8);
        CompareVO.Row waiting = vo.getRows().stream()
                .filter(r -> r.getField().equals("waiting")).findFirst().orElseThrow();
        assertThat(waiting.getValues()).containsExactly("90 天", "30 天");
        CompareVO.Row renewal = vo.getRows().stream()
                .filter(r -> r.getField().equals("renewal")).findFirst().orElseThrow();
        assertThat(renewal.getValues()).containsExactly("是", "否");
    }

    @Test
    void compareRejectsWrongSize() {
        assertThatThrownBy(() -> service.compare(List.of(1L)))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("2~4");
    }

    @Test
    void compareRequiresAtLeastTwoExistingProducts() {
        when(productMapper.selectBatchIds(List.of(1L, 2L)))
                .thenReturn(List.of(product(1, "产品一", 30, false)));

        assertThatThrownBy(() -> service.compare(List.of(1L, 2L)))
                .isInstanceOf(BizException.class)
                .hasMessageContaining("部分产品不存在");
    }
}
