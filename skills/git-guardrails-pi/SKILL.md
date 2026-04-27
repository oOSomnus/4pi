---
name: git-guardrails-pi
description: 设置 pi 钩子来阻止危险的 git 命令（push、reset --hard、clean、branch -D 等）在执行前被拦截。当用户想要防止破坏性的 git 操作、添加 git 安全钩子或在 pi 中阻止 git push/reset 时使用。
---

# 设置 Git 安全防护

设置 pi 扩展钩子，在 pi 执行危险的 git 命令之前拦截并阻止它们。

## 被阻止的命令

- `git push`（所有变体，包括 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

当被阻止时，pi 会看到一条消息告知它无权访问这些命令。

## 步骤

### 1. 询问范围

询问用户：安装为**仅此项目**（`.pi/extensions/`）还是**所有项目**（`~/.pi/agent/extensions/`）？

### 2. 创建 pi 扩展文件

创建 TypeScript 扩展文件来拦截危险命令：

**项目级**：`.pi/extensions/block-dangerous-git.ts`
**全局级**：`~/.pi/agent/extensions/block-dangerous-git.ts`

扩展内容如下：

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

const DANGEROUS_COMMANDS = [
  /git\s+push/,
  /git\s+reset\s+--hard/,
  /git\s+clean\s+-f/,
  /git\s+branch\s+-D/,
  /git\s+checkout\s+\./,
  /git\s+restore\s+\./,
];

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (isToolCallEventType("bash", event)) {
      const cmd = event.input.command || "";
      for (const pattern of DANGEROUS_COMMANDS) {
        if (pattern.test(cmd)) {
          return {
            block: true,
            reason: `已阻止危险的 git 命令：${cmd.trim()}。pi 无权执行此命令。`,
          };
        }
      }
    }
  });
}
```

### 3. 询问自定义

询问用户是否想要从阻止列表中添加或删除任何模式。相应地编辑扩展文件。

### 4. 验证

要求用户使用 `/reload` 重新加载扩展，或重新启动 pi。扩展将在下次启动时自动加载。
