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
