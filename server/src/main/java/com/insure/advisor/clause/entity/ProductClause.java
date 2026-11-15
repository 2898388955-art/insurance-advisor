package com.insure.advisor.clause.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("product_clause")
public class ProductClause {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long productId;

    private String docId;

    private String version;

    private LocalDate effectiveDate;

    private String filePath;

    private String fileHash;

    private Integer pageCount;

    private String status;

    private String fileType;

    private String regNo;

    private String clauseName;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
