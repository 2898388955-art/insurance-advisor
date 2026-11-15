"""把 MinerU 输出的 Markdown 归一化成结构化 Block。

MinerU 的 Markdown 是给人看的：标题层级不可靠、小节编号和标题常常被拆成两行、
表格每行都重复分隔线。本模块把它们整理成程序可用的 Block 序列，供后续切分使用。

用法：
    python -m app.ingest.normalize data/parsed/86803.md -o data/parsed/86803.blocks.jsonl
"""
from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass, field
from pathlib import Path

# ---------- 正则 ----------
PAGE_RE = re.compile(r"<!--\s*page\s+(\d+)\s+of\s+(\d+)\s*-->")
MD_HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$")
NUM_ONLY_RE = re.compile(r"^(\d+(?:\.\d+)*)\.?$")
NUM_TITLE_RE = re.compile(r"^(\d+(?:\.\d+)*)\.?\s+(\S.*)$")
CHAPTER_RE = re.compile(r"^(第[一二三四五六七八九十百零]+[章节])\s*(.+?)$")
# 保险条款常用「第X条」作为节级结构，如「第三条 保险责任」
ARTICLE_RE = re.compile(r"^(第[一二三四五六七八九十百零]+条)\s*(.*)$")
SUP_RE = re.compile(r"<sup>.*?</sup>", re.S)
LEADER_RE = re.compile(r"[.…·]{3,}")
IMAGE_RE = re.compile(r"^!\[[^\]]*\]\([^)]*\)$")
SEPARATOR_CELL_RE = re.compile(r"^:?-{3,}:?$")
END_PUNCT = "。！？；：，、"

CJK = re.compile(r"[一-鿿]")


@dataclass
class Block:
    type: str                 # heading | paragraph | table | image
    text: str
    page: int
    level: int = 0            # 仅 heading 使用，1/2/3
    heading_path: str = ""     # 形如 "7. 其他需要关注的事项 > 7.1 年龄错误"
    seq: int = 0


@dataclass
class _Heading:
    level: int
    label: str


def _clean_inline(text: str) -> str:
    text = SUP_RE.sub("", text)
    text = LEADER_RE.sub("", text)
    text = text.replace("　", " ")
    text = re.sub(r"[ \t]+", " ", text)
    text = text.replace("[本页内容结束]", "")
    return text.strip()


def _join_lines(lines: list[str]) -> str:
    """中文之间不加空格，中英文之间补一个空格。"""
    out = ""
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if not out:
            out = line
            continue
        if CJK.search(out[-1]) and CJK.search(line[0]):
            out += line
        else:
            out += " " + line
    return out


def _heading_level(num: str) -> int:
    parts = num.rstrip(".").split(".")
    return min(len(parts), 3)


def _is_title_like(text: str) -> bool:
    """短、无句末标点、不像正文句子。"""
    if not text or len(text) > 30:
        return False
    if text[-1] in END_PUNCT:
        return False
    if text.startswith(("（", "(", "1.", "2.", "3.", "4.", "5.", "#", "|", "!")):
        return False
    return True


def _starts_new_block(text: str) -> bool:
    """该行本身已经是独立结构（标题/表格/图片/编号），不能再当上一行编号的标题。"""
    return bool(
        MD_HEADING_RE.match(text)
        or CHAPTER_RE.match(text)
        or NUM_ONLY_RE.match(text)
        or text.startswith("|")
        or IMAGE_RE.match(text)
    )


def _split_table_cells(line: str) -> list[str]:
    return [c.strip() for c in line.strip().strip("|").split("|")]


def _repair_table(raw_lines: list[str]) -> list[Block]:
    """修复 MinerU 的表格：去掉重复分隔线；两列表转成键值文本。"""
    rows: list[list[str]] = []
    for line in raw_lines:
        cells = _split_table_cells(line)
        if all(SEPARATOR_CELL_RE.match(c) for c in cells if c):
            continue
        rows.append(cells)

    if not rows:
        return []

    widths = {len(r) for r in rows}
    if widths == {2}:
        # 两列表：键值对，转成「键：值」文本，对检索更友好
        lines = [f"{r[0]}：{r[1]}" for r in rows if r[0] and r[1]]
        return [Block(type="table", text="\n".join(lines), page=0)]
    if len(widths) == 1:
        header = rows[0]
        body = rows[1:]
        md = ["| " + " | ".join(header) + " |",
              "| " + " | ".join("---" for _ in header) + " |"]
        md += ["| " + " | ".join(r) + " |" for r in body]
        return [Block(type="table", text="\n".join(md), page=0)]
    # 列数不一致，宁可当段落也不要输出坏表格
    text = "\n".join(" | ".join(r) for r in rows)
    return [Block(type="paragraph", text=text, page=0)]


def normalize(markdown: str) -> list[Block]:
    # 按页码切片
    pages: list[tuple[int, str]] = []
    last_end = 0
    current_page = 1
    for m in PAGE_RE.finditer(markdown):
        segment = markdown[last_end:m.start()]
        if segment.strip():
            pages.append((current_page, segment))
        current_page = int(m.group(1))
        last_end = m.end()
    tail = markdown[last_end:]
    if tail.strip():
        pages.append((current_page, tail))

    blocks: list[Block] = []
    heading_stack: list[_Heading] = []

    for page, segment in pages:
        lines = segment.splitlines()
        i = 0
        while i < len(lines):
            line = _clean_inline(lines[i])
            if not line:
                i += 1
                continue

            # ---- 表格：收集连续以 | 开头的行 ----
            if line.startswith("|"):
                raw = []
                while i < len(lines):
                    cur = lines[i].strip()
                    if cur.startswith("|"):
                        raw.append(cur)
                        i += 1
                    else:
                        break
                for b in _repair_table(raw):
                    b.page = page
                    blocks.append(b)
                continue

            # ---- 图片占位 ----
            if IMAGE_RE.match(line):
                blocks.append(Block(type="image", text="", page=page))
                i += 1
                continue

            # ---- Markdown 硬标题 ----
            m = MD_HEADING_RE.match(line)
            if m:
                title = _clean_inline(m.group(2))
                level = 1 if len(m.group(1)) <= 2 else min(len(m.group(1)) - 1, 3)
                blocks.append(Block(type="heading", text=title, page=page, level=level))
                i += 1
                continue

            # ---- 中文章节：第X章 / 第X节 ----
            m = CHAPTER_RE.match(line)
            if m:
                title = _clean_inline(f"{m.group(1)} {m.group(2)}")
                if _is_title_like(title):
                    blocks.append(Block(type="heading", text=title, page=page, level=1))
                    i += 1
                    continue

            # ---- 中文章节：第X条 ----
            m = ARTICLE_RE.match(line)
            if m:
                title = _clean_inline(line)
                if _is_title_like(title):
                    blocks.append(Block(type="heading", text=title, page=page, level=2))
                    i += 1
                    continue

            # ---- 单独一行的编号，下一行是标题 ----
            m = NUM_ONLY_RE.match(line)
            if m:
                num = m.group(1)
                nxt_idx = i + 1
                while nxt_idx < len(lines) and not lines[nxt_idx].strip():
                    nxt_idx += 1
                if nxt_idx < len(lines):
                    nxt = _clean_inline(lines[nxt_idx])
                    if _is_title_like(nxt) and not _starts_new_block(nxt):
                        blocks.append(Block(
                            type="heading", text=f"{num} {nxt}", page=page,
                            level=_heading_level(num)))
                        i = nxt_idx + 1
                        continue
                # 找不到标题就当普通段落
                blocks.append(Block(type="paragraph", text=num, page=page))
                i += 1
                continue

            # ---- 行内编号 + 标题，如 "2. 我们提供的保障" ----
            m = NUM_TITLE_RE.match(line)
            if m and _is_title_like(m.group(2).strip()) and not m.group(2).strip().startswith("#"):
                num = m.group(1)
                blocks.append(Block(
                    type="heading", text=f"{num} {_clean_inline(m.group(2))}",
                    page=page, level=_heading_level(num)))
                i += 1
                continue

            # ---- 普通段落：吃到空行为止 ----
            para = [line]
            i += 1
            while i < len(lines):
                nxt = _clean_inline(lines[i])
                if (not nxt or nxt.startswith("|") or MD_HEADING_RE.match(nxt)
                        or NUM_ONLY_RE.match(nxt) or IMAGE_RE.match(nxt)
                        or (NUM_TITLE_RE.match(nxt) and _is_title_like(NUM_TITLE_RE.match(nxt).group(2).strip()))):
                    break
                para.append(nxt)
                i += 1
            text = _join_lines(para)
            if text:
                blocks.append(Block(type="paragraph", text=text, page=page))

    # ---- 第二遍：补全被换行截断的标题 ----
    # MinerU 常把标题末尾一两个字放到下一行，例如 "2.2 保险期间与不" + "保证续保"
    merged: list[Block] = []
    i = 0
    while i < len(blocks):
        cur = blocks[i]
        if (cur.type == "heading" and i + 1 < len(blocks)):
            nxt = blocks[i + 1]
            frag = nxt.text.strip()
            if (nxt.type == "paragraph" and 0 < len(frag) <= 6
                    and not any(ch.isdigit() for ch in frag)
                    and frag[-1] not in END_PUNCT
                    and cur.text[-1] not in END_PUNCT):
                cur.text = cur.text + frag
                i += 2
                merged.append(cur)
                continue
        merged.append(cur)
        i += 1
    blocks = merged

    # ---- 第三遍：补 level / heading_path / seq ----
    for idx, b in enumerate(blocks):
        b.seq = idx
        if b.type == "heading":
            while heading_stack and heading_stack[-1].level >= b.level:
                heading_stack.pop()
            heading_stack.append(_Heading(level=b.level, label=b.text))
            b.heading_path = " > ".join(h.label for h in heading_stack)
        else:
            b.heading_path = " > ".join(h.label for h in heading_stack)
    return blocks


def load(path: str | Path) -> list[Block]:
    return normalize(Path(path).read_text(encoding="utf-8"))


def main() -> None:
    parser = argparse.ArgumentParser(description="归一化 MinerU Markdown")
    parser.add_argument("input")
    parser.add_argument("-o", "--output", default=None, help="输出 JSONL 路径")
    args = parser.parse_args()

    blocks = load(args.input)
    if args.output:
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        with out.open("w", encoding="utf-8") as f:
            for b in blocks:
                f.write(json.dumps(asdict(b), ensure_ascii=False) + "\n")
        print(f"写入 {out}，共 {len(blocks)} 个 block")
    else:
        for b in blocks[:30]:
            print(f"[{b.type}] p{b.page} L{b.level} {b.heading_path} | {b.text[:60]}")


if __name__ == "__main__":
    main()
