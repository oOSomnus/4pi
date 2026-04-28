---
name: init
description: 为项目仓库初始化 AGENTS.md、个人偏好文件和可选的技能与 pi 扩展钩子。当用户说 /init、初始化项目、设置 AGENTS.md、配置项目上下文或首次为仓库建立 pi 工作环境时使用。
---

# /init — 初始化项目上下文

为当前仓库建立最小化的 AGENTS.md（以及可选的 skill 和 pi 扩展 hook）。AGENTS.md 会被加载到每个 pi 会话中，因此要简洁——只包含没有它 pi 会出错的内容。

## 阶段 1：询问要设置什么

使用 `ctx.ui.select` 和 `ctx.ui.confirm` 搞清楚用户想要什么：

**AGENTS.md 范围：**
- "项目 AGENTS.md" — 团队共享，提交到版本控制
- "个人 AGENTS.local.md" — 私有偏好（.gitignore），不共享
- "两者都设置"

**是否同时设置 skill 和 hook：**
- "Skill + hook" — 按需工作流 + 事件驱动的确定性操作
- "仅 skill" — 按需能力包
- "仅 hook" — 事件驱动的自动化
- "都不需要，只要 AGENTS.md"

## 阶段 2：探索代码库

启动子代理（或直接探索）查看关键文件：package.json / Cargo.toml / pyproject.toml / go.mod / pom.xml、README、Makefile、构建配置、CI 配置、现有 AGENTS.md、.pi/rules/、.cursor/rules/、.cursorrules、.github/copilot-instructions.md、.mcp.json。

检测：
- 构建、测试、lint 命令（尤其是非标准命令）
- 语言、框架、包管理器
- 项目结构（monorepo / 多模块 / 单项目）
- 偏离语言默认的代码风格规则
- 非显而易见的坑、必需的环境变量、工作流怪癖
- 已有的 .pi/skills/ 和 .pi/extensions/
- 格式化器配置（prettier、biome、ruff、black、gofmt、rustfmt 等）
- Git worktree 使用情况：`git worktree list`

记录**仅凭代码无法确定的内容**——这些变成后续面试问题。

## 阶段 3：填补空白

使用 `ctx.ui.select` / `ctx.ui.input` / `ctx.ui.confirm` 收集写好 AGENTS.md 和 skill 仍然缺少的信息。只问代码无法回答的问题。

如果选了项目 AGENTS.md：询问代码库实践——非显而易见的命令、坑、分支/PR 约定、环境配置怪癖。跳过 README 已覆盖或 manifest 文件显而易见的内容。不标记任何选项为"推荐"。

如果选了个人 AGENTS.local.md：询问用户本人——角色、对代码库的熟悉程度、个人沙箱 URL、测试账号、API key 路径。问沟通偏好（"简洁回答"、"总是解释权衡"、"结尾不要总结"）。

**根据阶段 2 的发现合成提案**，通过 `ctx.ui.select` 的选项展示。每个 item 决定最终产物类型：
- **Hook**（更严格）—— 基于事件的 pi 扩展（`pi.on("tool_call", ...)`），在编辑/写入/结束回合时确定性执行。适合格式化、快速 lint。
- **Skill**（按需）—— `.pi/skills/` 下的 SKILL.md，手动触发 `/skill:name`。适合深度验证、报告、部署。
- **AGENTS.md 注释**（最宽松）—— 影响行为但不强制执行。适合沟通/思考偏好。

**遵循阶段 1 的选择作为硬过滤**：用户选"仅 skill"，就把提议的 hook 降级为 skill 或注释。选"仅 hook"同理。选"都不要"则全变成 AGENTS.md 注释。

## 阶段 4：写入项目 AGENTS.md

写最小化的 AGENTS.md。每一行都通过测试："删掉这行会导致 pi 出错吗？"不过就删。

**消费阶段 3 中目标为 AGENTS.md 的 `note` 条目**——作为简洁行添加到对应章节。

包含：
- pi 猜不出的 构建/测试/lint 命令
- 偏离语言默认的代码风格规则
- 测试说明和怪癖
- 仓库礼仪（分支命名、PR 约定、commit 风格）
- 必需的环境变量或设置步骤
- 非显而易见的坑或架构决策
- 现有 AI 编码工具配置中的重要部分（AGENTS.md、.cursor/rules 等）

排除：
- 逐文件结构或组件列表
- pi 已知道的标准语言约定
- 通用建议（"写清晰的代码"、"处理错误"）
- 长教程——移到单独文件用 `@path/to/file` 引用
- 频繁变化的信息——用 `@path/to/import` 引用

文件前缀：
```
# AGENTS.md

This file provides guidance to pi when working with code in this repository.
```

如果 AGENTS.md 已存在：阅读后提出 diff 形式的修改建议，解释每条修改的原因。不静默覆盖。

对多关注点的项目，建议组织到 `.pi/rules/` 下作为独立文件。对 monorepo，提及子目录可以添加自己的 AGENTS.md。

## 阶段 5：写入个人 AGENTS.local.md

在项目根目录创建最小化的 AGENTS.local.md。创建后将其加入 `.gitignore`。

**消费阶段 3 中目标为 AGENTS.local.md 的 `note` 条目**。

包含：用户角色、熟悉程度、个人沙箱/测试账号、工作流/沟通偏好。

如果阶段 2 发现多个 git worktree 且用户确认使用 sibling/external worktree：实际内容写到 `~/.pi/<project-name>-instructions.md`，AGENTS.local.md 变成一行 stub：`@~/.pi/<project-name>-instructions.md`。不要让项目 AGENTS.md 引用个人文件。

如果 AGENTS.local.md 已存在：阅读后提出增补建议，不静默覆盖。

## 阶段 6：创建 skill

如果阶段 1 选了 skill：

**先消费阶段 3 队列中的 `skill` 条目**。每个队列中的 skill 偏好创建为 `.pi/skills/<skill-name>/SKILL.md`：

```yaml
---
name: <skill-name>
description: <能力描述及触发条件>
---

<给 pi 的指令>
```

**再建议额外 skill**，当发现：
- 子系统参考知识（约定、模式、风格指南）
- 用户想直接触发的可重复工作流（部署、验证、发布）

展示建议的 skill：名称、一行用途、为何适合此仓库。

如果 `.pi/skills/` 已有 skill：先审查，只建议互补的新 skill。用 `disable-model-invocation: true` 控制有副作用的工作流仅用户触发，用 `$ARGUMENTS` 接受参数。

## 阶段 7：创建 pi 扩展 hook

如果阶段 1 选了 hook：

**消费阶段 3 队列中的 `hook` 条目**。每个 hook 偏好创建为 `.pi/extensions/`（项目级）或 `~/.pi/agent/extensions/`（全局级）下的 TypeScript 文件。

Pi hook 使用 `pi.on()` 事件处理，而不是 Claude Code 的 hooks.json：

| 需求 | Pi 事件 |
|------|---------|
| 编辑/写入后格式化 | `pi.on("tool_call", ...)` + `isToolCallEventType("edit"\|"write", event)` |
| 回合结束验证 | `pi.on("turn_end", ...)` |
| bash 执行前拦截 | `pi.on("tool_call", ...)` + `isToolCallEventType("bash", event)` |
| 会话启动 | `pi.on("session_start", ...)` |

**格式化 hook 模板：**
```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (isToolCallEventType("edit", event) || isToolCallEventType("write", event)) {
      const path = "path" in event.input ? event.input.path : undefined;
      if (path && /\.(ts|tsx|js|jsx)$/.test(path)) {
        await pi.exec("npx", ["prettier", "--write", path]);
      }
    }
  });
}
```

**bash 拦截 hook 模板：**
```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (isToolCallEventType("bash", event)) {
      if (/rm\s+-rf/.test(event.input.command || "")) {
        const ok = await ctx.ui.confirm("危险操作", "允许 rm -rf 吗？");
        if (!ok) return { block: true, reason: "用户拒绝" };
      }
    }
  });
}
```

创建扩展后，提醒用户运行 `/reload` 或在下次启动时自动生效。

## 阶段 8：额外优化

检查环境并询问：
- **GitHub CLI**：`which gh`，缺失且项目用 GitHub 则建议安装
- **Linting**：阶段 2 未发现 lint 配置则建议设置
- **格式化 hook**：阶段 2 发现 formatter 但阶段 3 无格式化 hook 则提供 fallback

## 阶段 9：总结

总结已设置的文件及关键点。提醒用户这些是起点，可随时重新运行 `/init` 重新扫描。

然后给出一份针对此仓库的优化建议清单，按影响排序：
- 前端项目：建议安装 pi 的 playwright 或前端设计相关包/扩展
- 缺失测试：建议搭建测试框架
- 缺失 linting：建议设置
- 浏览 pi 官方包和扩展：`/pi help` 查看可用资源
