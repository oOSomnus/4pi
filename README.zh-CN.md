# 4pi

个人 pi coding agent 工具包 — extensions、skills、themes 一键安装。

[English](README.md)

## 目录

### Extensions（`extensions/`）

| 扩展 | 说明 |
|---|---|
| `block-dangerous-git` | 拦截危险的 git 命令（push、reset --hard、clean -f、branch -D） |
| `rtk-rewrite` | 通过 `rtk` 自动压缩 shell 命令，节省 60-90% token |

### Skills（`skills/`）

改编自 [mattpocock/skills](https://github.com/mattpocock/skills)：

- `browser-tools` — 基于 Chrome DevTools Protocol 的交互式浏览器自动化
- `caveman` — 超压缩沟通模式
- `design-an-interface` — 并行星代理接口设计
- `domain-model` — DDD 风格领域建模
- `edit-article` — 编辑和润色文章草稿
- `git-guardrails-pi` — Git 安全钩子
- `grill-me` — 无情追问，对方案进行压力测试
- `improve-codebase-architecture` — 深度模块重构
- `init` — 初始化项目的 AGENTS.md 和个人偏好文件
- `migrate-to-shoehorn` — 将 `as` 断言迁移到 @total-typescript/shoehorn
- `obsidian-vault` — Obsidian 知识库管理
- `organize-worklog` — 整理零散工作日志，按周汇总归档
- `qa` — 交互式 QA Bug 报告
- `request-refactor-plan` — 含微提交的重构规划
- `scaffold-exercises` — 练习目录脚手架
- `setup-pre-commit` — Husky pre-commit 钩子
- `staged-review` — Git 暂存区代码审查
- `tdd` — 测试驱动开发（红-绿-重构）
- `to-issues` — 将计划拆分为可追踪的任务
- `to-knowledge` — 提取项目隐知识到 `.pi/knowledge/`
- `to-worklog` — 将对话记录为工作日志
- `to-prd` — 将当前上下文转为 PRD
- `triage-issue` — Bug 分类与 TDD 修复方案
- `ubiquitous-language` — DDD 通用语言词汇表
- `websearch` — 通过 ddgr 进行 DuckDuckGo 网页搜索
- `write-a-skill` — 创建新的 pi 技能
- `zoom-out` — 从当前上下文抽离俯视

### Themes（`themes/`）

| 主题 | 说明 |
|---|---|
| `oosomnus-dark` | 暗色主题，红色点缀 |
| `oosomnus-light` | 亮色主题，红色点缀，蓝色高亮 |
| `gruvbox-dark` | Gruvbox 调色板的复古暖色调 |

## 前置条件

| 工具 | 用途 |
|---|---|
| `npm` | pi、pi-mcp-adapter、context-mode |
| `pip3`（或 `pip`） | ddgr（DuckDuckGo 命令行搜索） |
| `curl` | rtk 下载 |
| `git` | pi 包安装 |
| `bash` | 安装脚本 |

安装脚本会检查 `npm`、`curl`、`git`，缺失时直接报错退出。
`pip3`/`pip` 为可选 — 缺失时跳过 ddgr 并给出警告。

## 安装

### 一行命令

```bash
bash install.sh
```

使用项目级 context-mode 配置：

```bash
bash install.sh --project
```

### 手动安装

```bash
pi install git:github.com/oOSomnus/4pi
```

安装 context-mode：

```bash
npm install -g context-mode
pi install npm:context-mode

# 在 ~/.pi/agent/mcp.json 中添加：
# { "mcpServers": { "context-mode": { "command": "context-mode" } } }
```

## 许可证

MIT — 详见 [LICENSE](LICENSE)
