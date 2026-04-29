# 4pi

Personal pi coding agent bundle — extensions, skills, themes in one install.

[中文](README.zh-CN.md)

## Contents

### Extensions (`extensions/`)

| Extension | Description |
|---|---|
| `block-dangerous-git` | Blocks destructive git commands (push, reset --hard, clean -f, branch -D) |
| `rtk-rewrite` | Auto-rewrites shell commands via `rtk` for 60-90% token savings |

### Skills (`skills/`)

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills):

- `browser-tools` — Interactive browser automation via Chrome DevTools Protocol
- `caveman` — Ultra-compressed communication mode
- `design-an-interface` — Parallel sub-agent interface design
- `domain-model` — DDD-style domain modeling
- `edit-article` — Edit and improve article drafts
- `git-guardrails-pi` — Git safety hooks
- `grill-me` — Stress-test plans with relentless questioning
- `improve-codebase-architecture` — Deep module refactoring
- `init` — Initialize AGENTS.md and project preferences
- `migrate-to-shoehorn` — Migrate `as` assertions to @total-typescript/shoehorn
- `obsidian-vault` — Obsidian knowledge base management
- `organize-worklog` — Organize scattered worklog files into weekly summaries
- `qa` — Interactive QA bug reporting
- `request-refactor-plan` — Refactor planning with micro-commits
- `scaffold-exercises` — Exercise directory scaffolding
- `setup-pre-commit` — Husky pre-commit hooks
- `tdd` — Test-driven development (red-green-refactor)
- `to-issues` — Break plans into trackable issues
- `to-knowledge` — Extract implicit project knowledge to `.pi/knowledge/`
- `to-worklog` — Record conversation as worklog entry
- `to-prd` — Convert context to PRD
- `triage-issue` — Bug triage with TDD fix plans
- `ubiquitous-language` — DDD ubiquitous language glossary
- `websearch` — DuckDuckGo web search via ddgr
- `write-a-skill` — Create new pi skills
- `zoom-out` — Zoom out from current context

### Themes (`themes/`)

| Theme | Description |
|---|---|
| `oosomnus-dark` | Dark theme with red accents |
| `oosomnus-light` | Light theme with red accents, blue highlights |
| `gruvbox-dark` | Retro warm tones from Gruvbox palette |

## Prerequisites

| Tool | Required for |
|---|---|
| `npm` | pi, pi-mcp-adapter, context-mode |
| `pip3` (or `pip`) | ddgr (DuckDuckGo CLI) |
| `curl` | rtk download |
| `git` | pi package installs |
| `bash` | install script |

The install script checks `npm`, `curl`, `git` and aborts if missing.
`pip3`/`pip` is optional — ddgr is skipped with a warning if unavailable.

## Install

### One-liner

```bash
bash install.sh
```

With project-level context-mode config:

```bash
bash install.sh --project
```

### Manual

```bash
pi install git:github.com/oOSomnus/4pi
```

For context-mode:

```bash
npm install -g context-mode
pi install npm:context-mode

# Add to ~/.pi/agent/mcp.json:
# { "mcpServers": { "context-mode": { "command": "context-mode" } } }
```

## License

MIT — see [LICENSE](LICENSE)
