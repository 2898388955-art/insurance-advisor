package com.insure.advisor.product.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("product")
public class Product {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String externalId;

    private Long categoryId;

    private String name;

    private String company;

    private String code;

    private Integer minAge;

    private Integer maxAge;

    private BigDecimal minPremium;

    private BigDecimal maxPremium;

    private String periodDesc;

    private Integer waitingDays;

    private Boolean guaranteedRenewal;

    private String highlights;

    private String productType;

    private String targetAudience;

    private String paymentTerm;

    private String coverageTerm;

    private String saleStatus;

    private String registrationNo;

    private String issuerType;

    private String dataStatus;

    private String sourceUrl;

    private String importBatch;

    private String verifiedFrom;

    private BigDecimal fieldConfidence;

    private LocalDateTime fieldExtractedAt;

    private String priceDisplay;

    private String priceStatus;

    private String priceType;

    private String priceCase;

    private String rateDocPath;

    private BigDecimal priceMin;

    private BigDecimal priceMax;

    private Integer status;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
