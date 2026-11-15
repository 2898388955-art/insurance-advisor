package com.insure.advisor.category.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.insure.advisor.category.dto.CategoryNode;
import com.insure.advisor.category.entity.Category;
import com.insure.advisor.category.mapper.CategoryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryMapper categoryMapper;

    /**
     * 分类数量在几十条量级，一次全查再在内存组树，
     * 比递归查询数据库少 N 次往返。
     */
    public List<CategoryNode> tree() {
        List<Category> all = categoryMapper.selectList(
                new LambdaQueryWrapper<Category>().orderByAsc(Category::getSort));

        Map<Long, CategoryNode> nodes = new LinkedHashMap<>();
        for (Category c : all) {
            nodes.put(c.getId(), toNode(c));
        }

        List<CategoryNode> roots = new ArrayList<>();
        for (Category c : all) {
            CategoryNode node = nodes.get(c.getId());
            if (c.getParentId() == null || c.getParentId() == 0L) {
                roots.add(node);
                continue;
            }
            CategoryNode parent = nodes.get(c.getParentId());
            if (parent == null) {
                roots.add(node);  // 父节点缺失时降级为根，避免分类树丢数据
            } else {
                parent.getChildren().add(node);
            }
        }
        return roots;
    }

    private CategoryNode toNode(Category c) {
        CategoryNode node = new CategoryNode();
        node.setId(c.getId());
        node.setCode(c.getCode());
        node.setName(c.getName());
        node.setLevel(c.getLevel());
        return node;
    }
}
