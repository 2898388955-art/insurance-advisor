package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "产品详情")
public class ProductDetailVO extends ProductCardVO {

    private String paymentTerm;

    private String coverageTerm;

    private String saleStatus;

    private String registrationNo;

    private String issuerType;

    private String sourceUrl;

    private List<ClauseVO> clauses = new ArrayList<>();

    private List<ProductImageVO> images = new ArrayList<>();

    @Data
    @Schema(description = "条款文档")
    public static class ClauseVO {
        private String docId;
        private String clauseName;
        private String fileType;
        private Integer pageCount;
        private String status;
        private String regNo;
    }
}
