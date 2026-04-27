---
name: obsidian-vault
description: 在 Obsidian 知识库中搜索、创建和管理笔记，支持 wikilinks 和索引笔记。当用户想要在 Obsidian 中查找、创建或组织笔记时使用。
---

# Obsidian 知识库

## 知识库位置

`/mnt/d/Obsidian Vault/AI Research/`

根级别大多是扁平的。

## 命名约定

- **索引笔记**：聚合相关主题（例如 `Ralph Wiggum 索引.md`、`Skills 索引.md`、`RAG 索引.md`）
- 所有笔记名称使用**标题大小写**（Title Case）
- 不使用文件夹组织——改用链接和索引笔记

## 链接

- 使用 Obsidian `[[wikilinks]]` 语法：`[[笔记标题]]`
- 笔记在底部链接到依赖/相关笔记
- 索引笔记只是 `[[wikilinks]]` 的列表

## 工作流程

### 搜索笔记

```bash
# 按文件名搜索
find "/mnt/d/Obsidian Vault/AI Research/" -name "*.md" | grep -i "关键词"

# 按内容搜索
grep -rl "关键词" "/mnt/d/Obsidian Vault/AI Research/" --include="*.md"
```

或者直接在知识库路径上使用 Grep/Glob 工具。

### 创建新笔记

1. 对文件名使用**标题大小写**（Title Case）
2. 将内容写成一个学习单元（遵循知识库规则）
3. 在底部添加指向相关笔记的 `[[wikilinks]]`
4. 如果是编号序列的一部分，使用层级编号方案

### 查找相关笔记

在知识库中搜索 `[[笔记标题]]` 来查找反向链接：

```bash
grep -rl "\\[\\[笔记标题\\]\\]" "/mnt/d/Obsidian Vault/AI Research/"
```

### 查找索引笔记

```bash
find "/mnt/d/Obsidian Vault/AI Research/" -name "*索引*"
```
