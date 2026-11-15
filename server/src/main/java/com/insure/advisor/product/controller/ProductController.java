package com.insure.advisor.product.controller;

import com.insure.advisor.common.web.ApiResponse;
import com.insure.advisor.common.web.PageResult;
import com.insure.advisor.product.dto.CompareRequest;
import com.insure.advisor.product.dto.CompareVO;
import com.insure.advisor.product.dto.ProductCardVO;
import com.insure.advisor.product.dto.ProductDetailVO;
import com.insure.advisor.product.dto.ProductQuery;
import com.insure.advisor.product.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "保险产品")
@RestController
@RequestMapping("/api/v1/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @Operation(summary = "产品列表（筛选 + 分页）")
    @GetMapping
    public ApiResponse<PageResult<ProductCardVO>> list(@ModelAttribute ProductQuery query) {
        return ApiResponse.ok(productService.search(query));
    }

    @Operation(summary = "产品详情")
    @GetMapping("/{id}")
    public ApiResponse<ProductDetailVO> detail(@PathVariable Long id) {
        return ApiResponse.ok(productService.detail(id));
    }

    @Operation(summary = "产品对比（2~4 个）")
    @PostMapping("/compare")
    public ApiResponse<CompareVO> compare(@Valid @RequestBody CompareRequest request) {
        return ApiResponse.ok(productService.compare(request.getIds()));
    }
}
