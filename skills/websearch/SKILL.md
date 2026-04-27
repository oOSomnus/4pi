---
name: websearch
description: 使用 ddgr（终端版 DuckDuckGo）执行网络搜索，获取实时信息、最新文档和网页内容。当需要搜索最新技术文档、查阅 API 参考、查找错误解决方案、获取实时网络信息、搜索特定网站内容或用户说"搜索"、"查一下"、"上网找"时使用。
---

# Web 搜索（ddgr）

通过 `ddgr`（DuckDuckGo from terminal）执行网络搜索，获取实时网页信息。

## 快速开始

```bash
# 基本搜索（返回 10 条结果，无交互模式）
ddgr --np -n 10 "搜索关键词"

# JSON 格式输出（便于解析）
ddgr --np --json -n 5 "搜索关键词"

# 纯文本输出（默认格式，含序号、标题、摘要、URL）
ddgr --np -n 5 "搜索关键词"
```

## 常用搜索模式

### 站点限定搜索

```bash
# 只搜索某个网站
ddgr --np --json -n 5 -w github.com "关键词"

# 搜索 MDN 文档
ddgr --np --json -n 3 -w developer.mozilla.org "Array.prototype.map"

# 搜索 Stack Overflow
ddgr --np --json -n 3 -w stackoverflow.com "error message"
```

### 时间过滤

```bash
# 过去一天 (d)、一周 (w)、一月 (m)、一年 (y)
ddgr --np --json -t w "最新技术新闻"
ddgr --np --json -t m "新发布的框架"
```

### 区域搜索

```bash
# 中文区域搜索（中国大陆）
ddgr --np --json -r cn-zh "关键词"

# 英文区域搜索
ddgr --np --json -r us-en "keyword"
```

### 结果数量

```bash
# 调整每页结果数（0-25，默认 10）
ddgr --np --json -n 3 "关键词"   # 少量快速
ddgr --np --json -n 25 "关键词"  # 最大结果
```

## 使用场景

| 场景 | 命令模式 |
|------|----------|
| 查最新文档 | `-w docs.site.com` 限站点 |
| 查 API 用法 | `-w developer.mozilla.org` + API 名 |
| 查报错解决 | `-w stackoverflow.com` + 错误信息 |
| 查最新消息 | `-t w` 或 `-t d` 限时间 |
| 查中文资料 | `-r cn-zh` 区域搜索 |
| 快速概览 | `-n 3` 少量结果 |

## 输出格式说明

**默认文本格式**：序号 + 标题 + 摘要 + URL → 适合人工阅读

**JSON 格式**（`--json`）：结构化输出，包含 `title`、`abstract`、`url` → 适合程序化解析

## 注意事项

- `--np` 禁用交互模式，直接返回结果（脚本/自动化必需）
- `--json` 与 `--np` 搭配使用便于解析
- 单次最多返回 25 条结果
- 过于频繁的请求可能被限速，建议合理控制搜索频率
- 优先使用站点限定搜索（`-w`）提高结果精度
