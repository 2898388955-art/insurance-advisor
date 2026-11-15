"""父子块切分。

父块 = 一个二级标题（或没有二级标题时的一级标题）下的全部内容，用于命中后回填上下文。
子块 = 父块按段落/句子切成的 300~400 字片段，用于向量召回。
"""
from __future__ import annotations

import re
from dataclasses import dataclass

from app.ingest.normalize import Block

MAX_CHARS = 400
OVERLAP_CHARS = 60
MIN_PARENT_CHARS = 150   # 小于此长度的节并入相邻节，避免"只有标题"的父块
MAX_PARENT_CHARS = 800   # 超过此长度时，子块切分更细（见 build_children）
SENTENCE_RE = re.compile(r"(?<=[。！？；])")


@dataclass
class ParentChunk:
    heading_path: str
    content: str
    page_from: int
    page_to: int


@dataclass
class ChildChunk:
    parent_index: int
    heading_path: str
    content: str
    page_no: int
    token_cnt: int


def _split_long(text: str, limit: int) -> list[str]:
    """超长段落按句子切开，句子仍超长才硬切。"""
    if len(text) <= limit:
        return [text]
    pieces: list[str] = []
    buf = ""
    for sent in SENTENCE_RE.split(text):
        if not sent:
            continue
        if len(buf) + len(sent) > limit and buf:
            pieces.append(buf)
            buf = sent
        else:
            buf += sent
    if buf:
        pieces.append(buf)
    # 兜底：单句仍超长
    out: list[str] = []
    for p in pieces:
        while len(p) > limit:
            out.append(p[:limit])
            p = p[limit:]
        if p:
            out.append(p)
    return out


_STOP = set("的本合同我们您一二三四五六七八九十")


def _title_chars(text: str) -> set[str]:
    return {c for c in text if c not in _STOP and not c.isdigit()
            and not c.isspace() and c not in "、，。：；（）()"}


def body_precedes_heading(blocks: list[Block]) -> bool:
    """检测 MinerU 是否把正文排在了标题前面。

    做法：对每个二级标题，看它后面第一段与"本标题"和"下一个标题"哪个更匹配。
    这是启发式的，只用来决定整体顺序，不参与逐块判断。
    """
    heads = [(i, b) for i, b in enumerate(blocks)
             if b.type == "heading" and b.level <= 2]
    if len(heads) < 3:
        return False
    vote_cur = vote_next = 0
    for k in range(len(heads) - 1):
        idx, head = heads[k]
        nxt_idx, nxt_head = heads[k + 1]
        para = ""
        for j in range(idx + 1, len(blocks)):
            if blocks[j].type == "paragraph" and blocks[j].text.strip():
                para = blocks[j].text
                break
        if not para:
            continue
        cur_set = _title_chars(head.text)
        nxt_set = _title_chars(nxt_head.text)
        if cur_set and len(cur_set & set(para)) / len(cur_set) >= 0.5:
            vote_cur += 1
        if nxt_set and len(nxt_set & set(para)) / len(nxt_set) >= 0.5:
            vote_next += 1
    return vote_next > vote_cur


def _chapter_of(path: str) -> str:
    return path.split(">")[0].strip()


def merge_small_parents(parents: list[ParentChunk]) -> list[ParentChunk]:
    """把过短的节并入同章的相邻节。只按标题切会产生大量"只有标题"的块。"""
    if not parents:
        return parents
    merged: list[ParentChunk] = []
    for p in parents:
        if merged and len(p.content) < MIN_PARENT_CHARS and _chapter_of(merged[-1].heading_path) == _chapter_of(p.heading_path):
            prev = merged[-1]
            prev.content = prev.content + "\n" + p.content
            prev.page_to = max(prev.page_to, p.page_to)
        else:
            merged.append(ParentChunk(p.heading_path, p.content, p.page_from, p.page_to))
    # 开头若仍过短，并入下一节
    if len(merged) > 1 and len(merged[0].content) < MIN_PARENT_CHARS:
        merged[1].content = merged[0].content + "\n" + merged[1].content
        merged[1].page_from = min(merged[0].page_from, merged[1].page_from)
        merged.pop(0)
    return merged


def _build_parents_shifted(blocks: list[Block]) -> list[ParentChunk]:
    """正文在标题之前时，把每段正文归给它的"下一个"标题。"""
    runs: list[list[Block]] = []
    cur: list[Block] = []
    for b in blocks:
        if b.type == "heading" and b.level <= 2:
            runs.append(cur)
            cur = [b]
        else:
            cur.append(b)
    runs.append(cur)

    parents: list[ParentChunk] = []
    for i in range(1, len(runs)):
        head = runs[i][0]
        body = [x for x in runs[i - 1]
                if x.type != "image" and not (x.type == "heading" and x.level <= 2)]
        lines = [head.text] + [x.text for x in body if x.text.strip()]
        pages = [head.page] + [x.page for x in body if x.text.strip()]
        if len(lines) == 1:
            continue
        parents.append(ParentChunk(
            heading_path=head.heading_path,
            content="\n".join(lines),
            page_from=min(pages),
            page_to=max(pages),
        ))
    return parents


def build_parents(blocks: list[Block], body_before_heading: bool = False) -> list[ParentChunk]:
    if body_before_heading:
        return merge_small_parents(_build_parents_shifted(blocks))

    parents: list[ParentChunk] = []
    cur_heading = ""
    cur_lines: list[str] = []
    cur_pages: list[int] = []

    def flush() -> None:
        nonlocal cur_lines, cur_pages
        text = "\n".join(x for x in cur_lines if x.strip())
        if text.strip():
            parents.append(ParentChunk(
                heading_path=cur_heading,
                content=text,
                page_from=min(cur_pages) if cur_pages else 0,
                page_to=max(cur_pages) if cur_pages else 0,
            ))
        cur_lines, cur_pages = [], []

    for b in blocks:
        if b.type == "image":
            continue
        if b.type == "heading" and b.level <= 2:
            flush()
            cur_heading = b.heading_path
            cur_lines = [b.text]
            cur_pages = [b.page]
        else:
            cur_lines.append(b.text)
            cur_pages.append(b.page)
    flush()
    return merge_small_parents(parents)


def build_children(parents: list[ParentChunk]) -> list[ChildChunk]:
    children: list[ChildChunk] = []
    for pi, parent in enumerate(parents):
        paragraphs = [p for p in parent.content.split("\n") if p.strip()]
        cur: list[str] = []
        cur_len = 0
        cur_page = parent.page_from

        def flush(page: int) -> None:
            nonlocal cur, cur_len
            text = "".join(cur).strip()
            if text:
                children.append(ChildChunk(
                    parent_index=pi,
                    heading_path=parent.heading_path,
                    content=text,
                    page_no=page,
                    token_cnt=len(text),  # 中文近似：1 字≈1 token
                ))
            cur, cur_len = [], 0

        for para in paragraphs:
            for piece in _split_long(para, MAX_CHARS):
                if cur and cur_len + len(piece) > MAX_CHARS:
                    flush(cur_page)
                    # 重叠：把上一片段尾部带入新块，避免跨块语义断裂
                    tail = ""
                    if children and len(children[-1].content) > OVERLAP_CHARS:
                        tail = children[-1].content[-OVERLAP_CHARS:]
                    cur = [tail] if tail else []
                    cur_len = len(tail)
                if not cur:
                    cur_page = parent.page_from
                cur.append(piece)
                cur_len += len(piece)
        flush(cur_page)

    # 过滤过短碎片（如只有标题的 7 字块），但保证每个父块至少保留一块
    kept: list[ChildChunk] = []
    for pi in range(len(parents)):
        group = [c for c in children if c.parent_index == pi]
        if not group:
            continue
        good = [c for c in group if len(c.content) >= 20]
        kept.extend(good or [max(group, key=lambda c: len(c.content))])
    return kept
