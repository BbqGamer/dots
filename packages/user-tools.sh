#!/bin/bash
# Per-user toolchains and CLIs (not system packages). Safe to re-run.
set -u
rustup default stable
cargo install --locked himalaya impala podlet reddix stylua tree-sitter-cli code-radio-cli
uv tool install ruff; uv tool install ty; uv tool install basedpyright
uv tool install aider-chat; uv tool install apyanki; uv tool install ezdxf
uv tool install litellm; uv tool install pyzotero; uv tool install zotero-mcp-server
go install golang.org/x/tools/gopls@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
git config --global ghq.root ~/code
# Node via nvm (official package provides /usr/share/nvm/init-nvm.sh)
[ -r /usr/share/nvm/init-nvm.sh ] && . /usr/share/nvm/init-nvm.sh && nvm install 24 && \
    npm i -g @openai/codex @railway/cli @doist/todoist-cli @earendil-works/pi-coding-agent @playwright/cli @agentmemory/agentmemory
# Claude Code
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
