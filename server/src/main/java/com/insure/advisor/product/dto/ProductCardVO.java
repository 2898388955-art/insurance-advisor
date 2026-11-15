package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Data
@Schema(description = "产品卡片")
public class ProductCardVO {

    private Long id;

    private String externalId;

    private String name;

    private String company;

    private Long categoryId;

    private String categoryName;

    private String productType;

    private Integer minAge;

    private Integer maxAge;

    private BigDecimal minPremium;

    private BigDecimal maxPremium;

    private String periodDesc;

    private Integer waitingDays;

    private Boolean guaranteedRenewal;

    private String highlights;

    @Schema(description = "VERIFIED 有条款 / NO_CLAUSE 缺条款")
    private String dataStatus;

    @Schema(description = "clause_pdf 表示字段来自条款原文")
    private String verifiedFrom;

    private String coverImageUrl;

    @Schema(description = "价格展示文案，缺失时为「产品价格未公开」")
    private String priceDisplay;

    @Schema(description = "PUBLISHED / NO_RATE_TABLE / NOT_PUBLIC / NOT_APPLICABLE")
    private String priceStatus;

    private List<String> labels = new ArrayList<>();
}
