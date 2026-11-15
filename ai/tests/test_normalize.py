from app.ingest.normalize import normalize

SAMPLE = """<!-- page 1 of 2 -->

第一条 保险责任

本合同等待期为 30 日。

2.3

等待期

| 保险期间 | 1年 |
| --- | --- |
| 免赔额 | 500元 |

![图片](doc:1)

<!-- page 2 of 2 -->

7. 其他需要关注的事项
"""


def test_page_markers_and_types():
    blocks = normalize(SAMPLE)
    pages = {b.page for b in blocks}
    assert pages == {1, 2}
    assert any(b.type == "image" for b in blocks)


def test_article_heading_detected():
    blocks = normalize(SAMPLE)
    headings = [b.text for b in blocks if b.type == "heading"]
    assert "第一条 保险责任" in headings


def test_lone_number_merges_with_title():
    blocks = normalize(SAMPLE)
    headings = [b.text for b in blocks if b.type == "heading"]
    assert "2.3 等待期" in headings


def test_two_column_table_becomes_key_value():
    blocks = normalize(SAMPLE)
    table = next(b for b in blocks if b.type == "table")
    assert "保险期间：1年" in table.text
    assert "免赔额：500元" in table.text
    assert "---" not in table.text


def test_heading_path_applied():
    blocks = normalize(SAMPLE)
    para = next(b for b in blocks if b.type == "paragraph" and "等待期" in b.text)
    assert para.heading_path.startswith("第一条 保险责任")
