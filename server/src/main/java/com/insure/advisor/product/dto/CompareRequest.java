package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

@Data
@Schema(description = "产品对比请求")
public class CompareRequest {

    @NotEmpty(message = "至少选择 2 个产品")
    @Size(min = 2, max = 4, message = "最多对比 4 个产品")
    private List<Long> ids;
}
