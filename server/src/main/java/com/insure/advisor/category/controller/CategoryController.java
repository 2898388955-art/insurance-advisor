package com.insure.advisor.category.controller;

import com.insure.advisor.category.dto.CategoryNode;
import com.insure.advisor.category.service.CategoryService;
import com.insure.advisor.common.web.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "保险分类")
@RestController
@RequestMapping("/api/v1/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @Operation(summary = "分类树")
    @GetMapping("/tree")
    public ApiResponse<List<CategoryNode>> tree() {
        return ApiResponse.ok(categoryService.tree());
    }
}
