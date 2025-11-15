#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# AI Coding Agents Configuration Script (Codex & Claude)
#
# Version      Date              Author              Info
# 1.0          14-November-2025  Danylo Mikula       Initial Version:
#                                                    - Configures Codex and Claude
#                                                      with Context7 MCP integration
#
# ------------------------------------------------------------------------------

# ----------------------- Install Required Tools -------------------------------

gum style --foreground "#00FF00" --bold "Installing AI coding tools..."
brew install node codex
brew install --cask claude-code

# ----------------------- Codex Configuration ----------------------------------

gum style --foreground "#00FF00" --bold "Configuring Codex..."
CODEX_DIR="$HOME/.codex"
mkdir -p "$CODEX_DIR"

# Create AGENTS.md
cat > "$CODEX_DIR/AGENTS.md" <<'EOF'
# Global instructions

## context7 instructions
- Always use context7 when I need code generation, setup or configuration steps, or library/API documentation. This means you should automatically use the Context7 MCP tools to resolve library id and get library docs without me having to explicitly ask.
EOF

gum style --foreground "#00FF00" --bold "Created $CODEX_DIR/AGENTS.md"

# Create config.toml (overwrite if exists)
cat > "$CODEX_DIR/config.toml" <<'EOF'
model = "gpt-5.1-codex"
model_reasoning_effort = "high"

[mcp_servers.context7]
command = "npx"
args = ["-y", "@upstash/context7-mcp"]
EOF

gum style --foreground "#00FF00" --bold "Created $CODEX_DIR/config.toml"

# ----------------------- Claude Configuration ---------------------------------

gum style --foreground "#00FF00" --bold "Configuring Claude..."
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

# Create CLAUDE.md (overwrite if exists)
cat > "$CLAUDE_DIR/CLAUDE.md" <<'EOF'
# Context7 MCP usage
- Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.
EOF

gum style --foreground "#00FF00" --bold "Created $CLAUDE_DIR/CLAUDE.md"

# Enable MCP server for Claude
gum style --foreground "#00FF00" --bold "Enabling Context7 MCP server for Claude..."
claude mcp add context7 -- npx -y @upstash/context7-mcp

gum style --foreground "#00FF00" --bold "AI agents configuration complete!"
