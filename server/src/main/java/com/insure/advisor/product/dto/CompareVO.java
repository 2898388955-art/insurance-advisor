package com.insure.advisor.product.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Schema(description = "产品对比结果")
public class CompareVO {

    private List<ProductCardVO> products = new ArrayList<>();

    private List<Row> rows = new ArrayList<>();

    @Data
    @AllArgsConstructor
    public static class Row {
        private String field;
        private String label;
        private List<String> values;
    }
}
