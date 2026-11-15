package com.insure.advisor.product.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("product_image")
public class ProductImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long productId;

    private String objectKey;

    /** MAIN 主图 / GALLERY 图集 */
    private String type;

    private String contentType;

    private Integer sizeBytes;

    private Integer sort;

    private LocalDateTime createdAt;
}
