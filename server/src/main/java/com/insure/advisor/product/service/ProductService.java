package com.insure.advisor.product.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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
import com.insure.advisor.product.dto.ProductQuery;
import com.insure.advisor.product.entity.Product;
import com.insure.advisor.product.entity.ProductImage;
import com.insure.advisor.product.mapper.ProductImageMapper;
import com.insure.advisor.product.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final ProductImageMapper imageMapper;
    private final ProductClauseMapper clauseMapper;
    private final ProductImageService imageService;
    private final ObjectStorageService storage;

    public PageResult<ProductCardVO> search(ProductQuery q) {
        Page<Product> result = productMapper.selectPage(pageOf(q), buildQuery(q));
        Map<Long, String> categoryNames = categoryNames();
        Map<Long, String> covers = coverImages(result.getRecords().stream().map(Product::getId).toList());
        List<ProductCardVO> cards = result.getRecords().stream()
                .map(x -> toCard(x, categoryNames, covers))
                .toList();
        return PageResult.of(cards, result.getTotal(), result.getCurrent(), result.getSize());
    }

    private LambdaQueryWrapper<Product> buildQuery(ProductQuery q) {
        LambdaQueryWrapper<Product> w = new LambdaQueryWrapper<>();
        w.eq(Product::getStatus, 1);

        if (q.getCategoryId() != null) {
            List<Long> ids = categoryIds(q.getCategoryId());
            if (!ids.isEmpty()) {
                w.in(Product::getCategoryId, ids);
            }
        }
        if (q.getAge() != null) {
            // null 表示条款未披露，宽松放行避免产品消失
            w.and(x -> x.isNull(Product::getMinAge).or().le(Product::getMinAge, q.getAge()));
            w.and(x -> x.isNull(Product::getMaxAge).or().ge(Product::getMaxAge, q.getAge()));
        }
        if (q.getMaxWaitingDays() != null) {
            w.and(x -> x.isNull(Product::getWaitingDays).or().le(Product::getWaitingDays, q.getMaxWaitingDays()));
        }
        if (q.getGuaranteedRenewal() != null) {
            w.eq(Product::getGuaranteedRenewal, q.getGuaranteedRenewal());
        }
        if (StringUtils.hasText(q.getKeyword())) {
            String k = q.getKeyword().trim();
            w.and(x -> x.like(Product::getName, k)
                    .or().like(Product::getCompany, k)
                    .or().like(Product::getHighlights, k));
        }
        applySort(w, q.getSort());
        return w;
    }

    /** 选中一级分类时，同时包含其二级分类。 */
    private List<Long> categoryIds(Long categoryId) {
        return categoryMapper.selectList(new LambdaQueryWrapper<Category>()
                        .and(x -> x.eq(Category::getId, categoryId)
                                .or().eq(Category::getParentId, categoryId)))
                .stream().map(Category::getId).toList();
    }

    /** 保费大量缺失，排序时把 null 放最后，避免"暂无价格"的产品占据首屏。 */
    private void applySort(LambdaQueryWrapper<Product> w, String sort) {
        if ("premium_asc".equals(sort)) {
            w.last("ORDER BY (min_premium IS NULL) ASC, min_premium ASC");
        } else if ("premium_desc".equals(sort)) {
            w.last("ORDER BY (min_premium IS NULL) ASC, min_premium DESC");
        } else {
            w.orderByAsc(Product::getId);
        }
    }

    private Page<Product> pageOf(ProductQuery q) {
        int page = Math.max(1, q.getPage() == null ? 1 : q.getPage());
        int size = Math.min(50, Math.max(1, q.getSize() == null ? 12 : q.getSize()));
        return new Page<>(page, size);
    }

    public ProductDetailVO detail(Long id) {
        Product p = productMapper.selectById(id);
        if (p == null) {
            throw new BizException(4040, "产品不存在");
        }
        ProductDetailVO vo = new ProductDetailVO();
        ProductCardVO card = toCard(p, categoryNames(), coverImages(List.of(id)));
        BeanUtils.copyProperties(card, vo);

        vo.setPaymentTerm(p.getPaymentTerm());
        vo.setCoverageTerm(p.getCoverageTerm());
        vo.setSaleStatus(p.getSaleStatus());
        vo.setRegistrationNo(p.getRegistrationNo());
        vo.setIssuerType(p.getIssuerType());
        vo.setSourceUrl(p.getSourceUrl());

        List<ProductClause> clauses = clauseMapper.selectList(
                new LambdaQueryWrapper<ProductClause>().eq(ProductClause::getProductId, id));
        vo.setClauses(clauses.stream().map(this::toClauseVO).toList());
        vo.setImages(imageService.list(id));
        return vo;
    }

    public CompareVO compare(List<Long> ids) {
        if (ids == null || ids.size() < 2 || ids.size() > 4) {
            throw new BizException("请选择 2~4 个产品进行对比");
        }
        List<Product> products = productMapper.selectBatchIds(ids);
        Map<Long, Product> byId = products.stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        List<Product> ordered = ids.stream().map(byId::get).filter(Objects::nonNull).toList();
        if (ordered.size() < 2) {
            throw new BizException(4040, "部分产品不存在");
        }

        Map<Long, String> categoryNames = categoryNames();
        Map<Long, String> covers = coverImages(ordered.stream().map(Product::getId).toList());
        CompareVO vo = new CompareVO();
        vo.setProducts(ordered.stream().map(x -> toCard(x, categoryNames, covers)).toList());

        vo.getRows().add(row("productType", "产品类型", ordered, p -> nvl(p.getProductType())));
        vo.getRows().add(row("age", "投保年龄", ordered, this::ageText));
        vo.getRows().add(row("period", "保障期限", ordered, this::periodText));
        vo.getRows().add(row("waiting", "等待期", ordered, this::waitingText));
        vo.getRows().add(row("renewal", "保证续保", ordered, this::renewalText));
        vo.getRows().add(row("payment", "缴费期限", ordered, p -> nvl(p.getPaymentTerm())));
        vo.getRows().add(row("premium", "保费", ordered, this::priceShort));
        vo.getRows().add(row("data", "字段来源", ordered, this::sourceText));
        return vo;
    }

    // ---------- helpers ----------

    private CompareVO.Row row(String field, String label, List<Product> products,
                              Function<Product, String> f) {
        return new CompareVO.Row(field, label, products.stream().map(f).toList());
    }

    private ProductCardVO toCard(Product p, Map<Long, String> categoryNames, Map<Long, String> covers) {
        ProductCardVO vo = new ProductCardVO();
        vo.setId(p.getId());
        vo.setExternalId(p.getExternalId());
        vo.setName(p.getName());
        vo.setCompany(p.getCompany());
        vo.setCategoryId(p.getCategoryId());
        vo.setCategoryName(categoryNames.get(p.getCategoryId()));
        vo.setProductType(p.getProductType());
        vo.setMinAge(p.getMinAge());
        vo.setMaxAge(p.getMaxAge());
        vo.setMinPremium(p.getMinPremium());
        vo.setMaxPremium(p.getMaxPremium());
        vo.setPeriodDesc(p.getPeriodDesc());
        vo.setWaitingDays(p.getWaitingDays());
        vo.setGuaranteedRenewal(p.getGuaranteedRenewal());
        vo.setHighlights(p.getHighlights());
        vo.setDataStatus(p.getDataStatus());
        vo.setVerifiedFrom(p.getVerifiedFrom());
        vo.setCoverImageUrl(covers.get(p.getId()));
        vo.setPriceDisplay(premiumText(p));
        vo.setPriceStatus(p.getPriceStatus());
        vo.getLabels().addAll(labels(p));
        return vo;
    }

    private List<String> labels(Product p) {
        List<String> list = new ArrayList<>();
        if (p.getWaitingDays() != null) {
            list.add("等待期 " + p.getWaitingDays() + " 天");
        }
        if (Boolean.TRUE.equals(p.getGuaranteedRenewal())) {
            list.add("保证续保");
        } else if (Boolean.FALSE.equals(p.getGuaranteedRenewal())) {
            list.add("不保证续保");
        }
        if ("NO_CLAUSE".equals(p.getDataStatus())) {
            list.add("条款待补充");
        } else if ("clause_pdf".equals(p.getVerifiedFrom())) {
            list.add("条款原文抽取");
        }
        if (!"PUBLISHED".equals(p.getPriceStatus())) {
            list.add("价格未公开");
        }
        return list;
    }

    private ProductDetailVO.ClauseVO toClauseVO(ProductClause c) {
        ProductDetailVO.ClauseVO cv = new ProductDetailVO.ClauseVO();
        cv.setDocId(c.getDocId());
        cv.setClauseName(c.getClauseName());
        cv.setFileType(c.getFileType());
        cv.setPageCount(c.getPageCount());
        cv.setStatus(c.getStatus());
        cv.setRegNo(c.getRegNo());
        return cv;
    }

    private String periodText(Product p) {
        return nvl(firstNonBlank(p.getCoverageTerm(), p.getPeriodDesc()));
    }

    private String waitingText(Product p) {
        return p.getWaitingDays() == null ? "条款未披露" : p.getWaitingDays() + " 天";
    }

    private String renewalText(Product p) {
        if (p.getGuaranteedRenewal() == null) {
            return "条款未提及";
        }
        return p.getGuaranteedRenewal() ? "是" : "否";
    }

    private String sourceText(Product p) {
        return "clause_pdf".equals(p.getVerifiedFrom()) ? "条款原文抽取" : "未核验";
    }

    private String ageText(Product p) {
        if (p.getMinAge() == null && p.getMaxAge() == null) {
            return "条款未披露";
        }
        String min = p.getMinAge() == null ? "不限" : p.getMinAge() + "";
        String max = p.getMaxAge() == null ? "不限" : p.getMaxAge() + "";
        return min + "-" + max + " 岁";
    }

    private String premiumText(Product p) {
        if (StringUtils.hasText(p.getPriceDisplay())) {
            return p.getPriceDisplay();
        }
        return "产品价格未公开";
    }

    /** 对比表格用短文案，避免把 100 多字的费率说明塞进单元格 */
    private String priceShort(Product p) {
        if (p.getMinPremium() != null) {
            return "¥" + p.getMinPremium().stripTrailingZeros().toPlainString() + " 起";
        }
        if ("PUBLISHED".equals(p.getPriceStatus())) {
            return "按费率表计价";
        }
        return "价格未公开";
    }

    private String nvl(String s) {
        return StringUtils.hasText(s) ? s : "条款未披露";
    }

    private String firstNonBlank(String a, String b) {
        return StringUtils.hasText(a) ? a : b;
    }

    private Map<Long, String> categoryNames() {
        return categoryMapper.selectList(null).stream()
                .collect(Collectors.toMap(Category::getId, Category::getName));
    }

    private Map<Long, String> coverImages(List<Long> productIds) {
        if (productIds.isEmpty()) {
            return Map.of();
        }
        List<ProductImage> images = imageMapper.selectList(new LambdaQueryWrapper<ProductImage>()
                .in(ProductImage::getProductId, productIds)
                .orderByAsc(ProductImage::getSort));
        Map<Long, String> out = new HashMap<>();
        for (ProductImage img : images) {
            out.putIfAbsent(img.getProductId(), storage.presignGet(img.getObjectKey()).toString());
        }
        return out;
    }

}
