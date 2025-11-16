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
brew install node claude-code codex

# ----------------------- Codex Configuration ----------------------------------

gum style --foreground "#00FF00" --bold "Configuring Codex..."

# Sync Codex dotfiles
stow codex

# Create config.toml (overwrite if exists)
CODEX_DIR="$HOME/.codex"
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

# Sync Claude dotfiles
stow claude

# Enable MCP server for Claude
gum style --foreground "#00FF00" --bold "Enabling Context7 MCP server for Claude..."
claude mcp add context7 -- npx -y @upstash/context7-mcp

gum style --foreground "#00FF00" --bold "AI agents configuration complete!"
