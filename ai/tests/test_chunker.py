from app.ingest.chunker import (body_precedes_heading, build_children,
                                build_parents)
from app.ingest.normalize import Block


def b(type_: str, text: str, level: int = 0, path: str = "", page: int = 1) -> Block:
    return Block(type=type_, text=text, page=page, level=level, heading_path=path)


def test_parents_follow_level_two_headings():
    blocks = [
        b("heading", "2. 我们提供的保障", 1, "2. 我们提供的保障"),
        b("paragraph", "总述内容。" * 40, path="2. 我们提供的保障"),
        b("heading", "2.3 等待期", 2, "2. 我们提供的保障 > 2.3 等待期"),
        b("paragraph", "等待期为 30 日。" * 20, path="2. 我们提供的保障 > 2.3 等待期"),
    ]
    parents = build_parents(blocks)
    assert len(parents) == 2
    assert parents[1].heading_path.endswith("2.3 等待期")
    assert "等待期为 30 日" in parents[1].content
    assert parents[1].page_from == 1


def test_children_split_long_section():
    long_text = "等待期条款。" * 200
    blocks = [
        b("heading", "2.3 等待期", 2, "2.3 等待期"),
        b("paragraph", long_text, path="2.3 等待期"),
    ]
    parents = build_parents(blocks)
    children = build_children(parents)
    assert len(children) > 1
    assert all(c.parent_index == 0 for c in children)
    assert max(len(c.content) for c in children) <= 470


def test_body_precedes_heading_detection():
    blocks = [
        b("heading", "1.1 等待期", 2, "1.1 等待期"),
        b("paragraph", "免赔额是指……", path="1.1 等待期"),
        b("heading", "1.2 免赔额", 2, "1.2 免赔额"),
        b("paragraph", "等待期是指……", path="1.2 免赔额"),
        b("heading", "1.3 责任免除", 2, "1.3 责任免除"),
        b("paragraph", "责任免除包括……", path="1.3 责任免除"),
    ]
    assert body_precedes_heading(blocks) is True


def test_parent_merge_short_sections():
    blocks = [
        b("heading", "1. 合同", 1, "1. 合同"),
        b("paragraph", "短", path="1. 合同"),
        b("heading", "1.1 构成", 2, "1. 合同 > 1.1 构成"),
        b("paragraph", "也很短", path="1. 合同 > 1.1 构成"),
    ]
    parents = build_parents(blocks)
    assert len(parents) == 1
