#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 4pi + context-mode 一键安装脚本
# 用法: bash install.sh [--project]
#   --project: context-mode mcp.json 写入项目级 .pi/mcp.json
# ============================================================

PROJECT_MODE=false
for arg in "$@"; do
  case "$arg" in
    --project) PROJECT_MODE=true ;;
  esac
done

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step()  { echo -e "\n${GREEN}==>${NC} ${YELLOW}$1${NC}"; }

# ============================================================
# Step 1: 安装 pi
# ============================================================
step "1/5 安装 pi coding agent"

if command -v pi &>/dev/null; then
  info "pi 已安装: $(pi --version 2>/dev/null || echo 'unknown')"
else
  info "安装 @mariozechner/pi-coding-agent..."
  npm install -g @mariozechner/pi-coding-agent
  info "pi 安装完成: $(pi --version 2>/dev/null)"
fi

# ============================================================
# Step 2: 安装 4pi（extensions + skills + themes 合一）
# ============================================================
step "2/5 安装 4pi (extensions + skills + themes)"

pi install git:github.com/oOSomnus/4pi 2>&1
info "4pi 安装完成"

# ============================================================
# Step 3: 安装 rtk（命令输出压缩工具）
# ============================================================
step "3/5 安装 rtk"

if command -v rtk &>/dev/null; then
  info "rtk 已安装: $(rtk --version 2>/dev/null || echo 'ok')"
else
  info "下载 rtk 预编译二进制..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  info "rtk 安装完成"
fi

# ============================================================
# Step 4: 安装 pi-mcp-adapter
# ============================================================
step "4/5 安装 pi-mcp-adapter"

pi install npm:pi-mcp-adapter 2>&1
info "pi-mcp-adapter 安装完成"

# ============================================================
# Step 5: 安装 context-mode
# ============================================================
step "5/5 安装 context-mode"

info "npm install -g context-mode..."
npm install -g context-mode 2>&1

info "pi install npm:context-mode..."
pi install npm:context-mode 2>&1

if $PROJECT_MODE; then
  MCP_FILE=".pi/mcp.json"
  mkdir -p .pi
else
  MCP_FILE="$HOME/.pi/agent/mcp.json"
  mkdir -p "$(dirname "$MCP_FILE")"
fi

# 智能合并已有配置
if [ -f "$MCP_FILE" ]; then
  python3 -c "
import json
with open('$MCP_FILE') as f:
    config = json.load(f)
config.setdefault('mcpServers', {})
config['mcpServers']['context-mode'] = {'command': 'context-mode'}
with open('$MCP_FILE', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
"
else
  cat > "$MCP_FILE" <<'MCPEOF'
{
  "mcpServers": {
    "context-mode": {
      "command": "context-mode"
    }
  }
}
MCPEOF
fi
info "context-mode 配置写入: $MCP_FILE"

# ============================================================
# 完成
# ============================================================
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  安装完成！${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "已安装:"
echo "  pi:             $(pi --version 2>/dev/null || echo 'check')"
echo "  4pi:            extensions + skills + themes (github.com/oOSomnus/4pi)"
echo "  rtk:            $(rtk --version 2>/dev/null || echo 'installed')"
echo "  mcp-adapter:    pi-mcp-adapter"
echo "  context-mode:   $(context-mode --version 2>/dev/null || echo 'installed')"
echo "  mcp.json:       $MCP_FILE"
echo ""
echo "运行 pi 开始。"
