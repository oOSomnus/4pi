---
name: scaffold-exercises
description: 创建包含章节、问题、解决方案和讲解的练习目录结构，并确保通过 lint 检查。当用户想要搭建练习框架、创建练习桩或设置新的课程章节时使用。
---

# 搭建练习框架

创建通过 `pnpm ai-hero-cli internal lint` 验证的练习目录结构，然后用 `git commit` 提交。

## 目录命名

- **章节（Sections）**：`exercises/` 下的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **练习（Exercises）**：章节内的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 章节编号 = `XX`，练习编号 = `XX.YY`
- 名称使用短横线命名（小写，连字符）

## 练习变体

每个练习至少需要一个以下子文件夹：

- `problem/` - 带 TODO 的学生工作区
- `solution/` - 参考实现
- `explainer/` - 概念性材料，无 TODO

桩时默认使用 `explainer/`，除非计划另有规定。

## 必需文件

每个子文件夹（`problem/`、`solution/`、`explainer/`）需要一个 `readme.md`，该文件：

- **不为空**（必须有真实内容，即使只有一行标题也行）
- 没有损坏的链接

桩时创建一个带标题和描述的最小 readme：

```md
# 练习标题

此处为描述
```

如果子文件夹有代码，还需要一个 `main.ts`（>1 行）。但对于桩，仅 readme 的练习是可以的。

## 工作流程

1. **解析计划** - 提取章节名称、练习名称和变体类型
2. **创建目录** - `mkdir -p` 为每个路径创建
3. **创建桩 readme** - 每个变体文件夹一个带标题的 `readme.md`
4. **运行 lint** - `pnpm ai-hero-cli internal lint` 验证
5. **修复任何错误** - 迭代直到 lint 通过

## Lint 规则摘要

linter（`pnpm ai-hero-cli internal lint`）检查：

- 每个练习有子文件夹（`problem/`、`solution/`、`explainer/`）
- 至少存在 `problem/`、`explainer/` 或 `explainer.1/` 之一
- 主子文件夹中 `readme.md` 存在且非空
- 没有 `.gitkeep` 文件
- 没有 `speaker-notes.md` 文件
- readme 中没有损坏的链接
- readme 中没有 `pnpm run exercise` 命令
- 每个子文件夹需要 `main.ts`，除非仅是 readme

## 移动/重命名练习

重新编号或移动练习时：

1. 使用 `git mv`（而不是 `mv`）重命名目录——保留 git 历史
2. 更新数字前缀以维持顺序
3. 移动后重新运行 lint

示例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 示例：从计划创建桩

给定如下计划：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

创建：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然后创建 readme 桩：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
