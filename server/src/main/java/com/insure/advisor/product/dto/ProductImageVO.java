package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "产品图片")
public class ProductImageVO {

    private Long id;

    private String type;

    @Schema(description = "预签名访问地址，有效期见配置")
    private String url;

    private Integer sort;
}
