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

require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    err "未找到 $1。请先安装: $2"
  fi
}

# ============================================================
# 前置条件检查
# ============================================================
echo -e "${YELLOW}检查前置条件...${NC}"
require_cmd npm   "https://nodejs.org (推荐 nvm: https://github.com/nvm-sh/nvm)"
require_cmd curl  "sudo apt install curl / brew install curl"
require_cmd git   "sudo apt install git / brew install git"
if command -v pip3 &>/dev/null || command -v pip &>/dev/null; then
  info "pip 可用"
else
  warn "未找到 pip3/pip — ddgr 将跳过。安装 Python 及 pip: https://www.python.org"
fi
echo ""

# ============================================================
# Step 1: 安装 pi
# ============================================================
step "1/6 安装 pi coding agent"

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
step "2/6 安装 4pi (extensions + skills + themes)"

pi install git:github.com/oOSomnus/4pi 2>&1
info "4pi 安装完成"

# ============================================================
# Step 3: 安装 rtk（命令输出压缩工具）
# ============================================================
step "3/6 安装 rtk"

if command -v rtk &>/dev/null; then
  info "rtk 已安装: $(rtk --version 2>/dev/null || echo 'ok')"
else
  info "下载 rtk 预编译二进制..."
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
  info "rtk 安装完成"
fi

# ============================================================
# Step 4: 安装 ddgr（DuckDuckGo 终端搜索）
# ============================================================
step "4/6 安装 ddgr"

if command -v ddgr &>/dev/null; then
  info "ddgr 已安装: $(ddgr --version 2>/dev/null || echo 'ok')"
else
  if command -v pip3 &>/dev/null; then
    info "pip3 install ddgr..."
    pip3 install ddgr 2>&1
    info "ddgr 安装完成"
  elif command -v pip &>/dev/null; then
    info "pip install ddgr..."
    pip install ddgr 2>&1
    info "ddgr 安装完成"
  else
    warn "未找到 pip3/pip，跳过 ddgr 安装。请手动安装: https://github.com/jarun/ddgr"
  fi
fi

# ============================================================
# Step 5: 安装 pi-mcp-adapter
# ============================================================
step "5/6 安装 pi-mcp-adapter"

pi install npm:pi-mcp-adapter 2>&1
info "pi-mcp-adapter 安装完成"

# ============================================================
# Step 6: 安装 context-mode
# ============================================================
step "6/6 安装 context-mode"

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
echo "  ddgr:           $(ddgr --version 2>/dev/null || echo 'not installed')"
echo "  mcp-adapter:    pi-mcp-adapter"
echo "  context-mode:   $(context-mode --version 2>/dev/null || echo 'installed')"
echo "  mcp.json:       $MCP_FILE"
echo ""
echo "运行 pi 开始。"
