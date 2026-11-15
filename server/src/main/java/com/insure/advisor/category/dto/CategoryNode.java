package com.insure.advisor.category.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Schema(description = "分类树节点")
public class CategoryNode {

    private Long id;

    private String code;

    private String name;

    @Schema(description = "1 一级分类，2 二级分类")
    private Integer level;

    private List<CategoryNode> children = new ArrayList<>();
}
