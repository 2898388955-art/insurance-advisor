package com.insure.advisor.product.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.insure.advisor.product.entity.Product;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {
}
