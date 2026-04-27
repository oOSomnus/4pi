/**
 * RTK Rewrite Extension for pi
 *
 * Intercepts bash tool calls and rewrites commands via `rtk rewrite`
 * for token savings (60-90% on dev operations).
 *
 * Requires: rtk >= 0.23.0
 *
 * Based on the Claude Code rtk-rewrite.sh PreToolUse hook,
 * adapted to pi's in-process extension model.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { execFileSync } from "node:child_process";

function checkRtkVersion(): { ok: boolean; version?: string } {
  try {
    const out = execFileSync("rtk", ["--version"], { encoding: "utf-8" });
    const match = out.match(/(\d+)\.(\d+)\.(\d+)/);
    if (!match) return { ok: false };

    const major = parseInt(match[1], 10);
    const minor = parseInt(match[2], 10);
    if (major === 0 && minor < 23) {
      return { ok: false, version: match[0] };
    }
    return { ok: true, version: match[0] };
  } catch {
    return { ok: false };
  }
}

function rewriteCommand(cmd: string): {
  rewritten: string;
  exitCode: number;
  error?: string;
} {
  try {
    const rewritten = execFileSync("rtk", ["rewrite", cmd], {
      encoding: "utf-8",
      stdio: ["ignore", "pipe", "ignore"], // capture stdout, ignore stderr
    }).trim();
    return { rewritten, exitCode: 0 };
  } catch (e: unknown) {
    const err = e as { status?: number; stdout?: string; message?: string };
    const code = typeof err.status === "number" ? err.status : 1;
    const rewritten = (typeof err.stdout === "string" ? err.stdout : "").trim();
    return { rewritten, exitCode: code, error: err.message };
  }
}

export default function (pi: ExtensionAPI) {
  // --- Startup: check rtk availability ---
  const { ok: rtkOk, version } = checkRtkVersion();

  if (!rtkOk) {
    const reason = version
      ? `rtk ${version} too old (need >= 0.23.0)`
      : "rtk not found";

    pi.on("session_start", async (_event, ctx) => {
      ctx.ui.notify(
        `[rtk-rewrite] DISABLED: ${reason}. Install: https://github.com/rtk-ai/rtk`,
        "warning",
      );
    });
    return;
  }

  // Track whether we've shown the active notification
  let notified = false;

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setStatus("rtk", `RTK ✓ (v${version})`);
  });

  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash") return;

    const cmd = (event.input as { command?: string }).command;
    if (!cmd) return;

    // Skip rtk meta-commands (already optimized)
    if (cmd.startsWith("rtk ")) return;

    const { rewritten, exitCode, error } = rewriteCommand(cmd);

    switch (exitCode) {
      case 0:
      case 3: {
        // Rewrite found (0=auto, 3=ask→auto in pi).
        // Claude Code treats exit 3 as "ask user"; pi auto-applies
        // since RTK rewrites are non-destructive.
        if (cmd === rewritten) return;
        event.input.command = rewritten;

        if (!notified) {
          ctx.ui.notify(
            `[rtk] Auto-rewriting commands for token savings (v${version})`,
            "info",
          );
          notified = true;
        }
        break;
      }

      case 1:
        // No RTK equivalent → pass through unchanged.
        break;

      case 2:
        // Deny rule matched → pass through (other handlers may block).
        break;

      default: {
        // Unexpected exit code → pass through.
        if (error) {
          ctx.ui.notify(`[rtk] rewrite failed: ${error}`, "error");
        }
        break;
      }
    }
  });
}
