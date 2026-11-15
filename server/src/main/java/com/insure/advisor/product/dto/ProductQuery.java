package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Schema(description = "产品筛选条件")
public class ProductQuery {

    private Long categoryId;

    @Schema(description = "投保人年龄，用于过滤可投产品")
    private Integer age;

    @Schema(description = "等待期上限（天）")
    private Integer maxWaitingDays;

    private Boolean guaranteedRenewal;

    private String keyword;

    @Schema(description = "premium_asc / premium_desc，默认按上架顺序")
    private String sort;

    private Integer page = 1;

    private Integer size = 12;
}
