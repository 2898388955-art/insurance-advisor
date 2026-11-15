package com.insure.advisor.category.service;

import com.insure.advisor.category.dto.CategoryNode;
import com.insure.advisor.category.entity.Category;
import com.insure.advisor.category.mapper.CategoryMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CategoryServiceTest {

    @Mock
    private CategoryMapper categoryMapper;

    @InjectMocks
    private CategoryService categoryService;

    private Category category(long id, long parentId, String name, int level, int sort) {
        Category c = new Category();
        c.setId(id);
        c.setParentId(parentId);
        c.setName(name);
        c.setCode("C" + id);
        c.setLevel(level);
        c.setSort(sort);
        return c;
    }

    @Test
    void buildsTreeFromFlatList() {
        when(categoryMapper.selectList(any())).thenReturn(List.of(
                category(1, 0, "医疗险", 1, 20),
                category(11, 1, "百万医疗", 2, 21),
                category(12, 1, "门急诊", 2, 22)
        ));

        List<CategoryNode> tree = categoryService.tree();

        assertThat(tree).hasSize(1);
        assertThat(tree.get(0).getName()).isEqualTo("医疗险");
        assertThat(tree.get(0).getChildren()).hasSize(2);
        assertThat(tree.get(0).getChildren().get(0).getName()).isEqualTo("百万医疗");
    }

    @Test
    void orphanNodeBecomesRoot() {
        when(categoryMapper.selectList(any())).thenReturn(List.of(
                category(1, 0, "医疗险", 1, 20),
                category(99, 404, "孤儿节点", 2, 21)
        ));

        List<CategoryNode> tree = categoryService.tree();

        assertThat(tree).hasSize(2);
        assertThat(tree).extracting(CategoryNode::getName)
                .containsExactlyInAnyOrder("医疗险", "孤儿节点");
    }
}
