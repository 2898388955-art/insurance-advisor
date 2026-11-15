package com.insure.advisor.product.controller;

import com.insure.advisor.common.web.ApiResponse;
import com.insure.advisor.product.dto.ProductImageVO;
import com.insure.advisor.product.service.ProductImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Tag(name = "产品图片")
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class ProductImageController {

    private final ProductImageService imageService;

    @Operation(summary = "上传产品图（后台）")
    @PostMapping(value = "/admin/products/{productId}/images",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ProductImageVO> upload(@PathVariable Long productId,
                                              @RequestParam("file") MultipartFile file,
                                              @RequestParam(defaultValue = "MAIN") String type) {
        return ApiResponse.ok(imageService.upload(productId, file, type));
    }

    @Operation(summary = "产品图片列表（预签名 URL）")
    @GetMapping("/products/{productId}/images")
    public ApiResponse<List<ProductImageVO>> list(@PathVariable Long productId) {
        return ApiResponse.ok(imageService.list(productId));
    }
}
