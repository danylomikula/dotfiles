#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# AI Coding Agents Configuration Script (Codex & Claude)
#
# Version      Date              Author              Info
# 1.0          14-November-2025  Danylo Mikula       Initial Version:
#                                                    - Configures Codex and Claude
#                                                      with Context7 MCP integration
# 1.1          23-November-2025  Danylo Mikula       Add interactive agent selection:
#                                                    - User can choose which agents to configure
#                                                    - Install only selected agent packages
#
# ------------------------------------------------------------------------------

# ----------------------- User Selection ---------------------------------------

gum style --foreground "#00FF00" --bold "Select which AI agents to configure:"

CONFIGURE_CODEX=$(gum confirm "Configure Codex?" && echo "yes" || echo "no")
CONFIGURE_CLAUDE=$(gum confirm "Configure Claude?" && echo "yes" || echo "no")

if [[ "$CONFIGURE_CODEX" == "no" && "$CONFIGURE_CLAUDE" == "no" ]]; then
    gum style --foreground "#FFFF00" --bold "No agents selected. Exiting."
    exit 0
fi

# ----------------------- Install Required Tools -------------------------------

gum style --foreground "#00FF00" --bold "Installing required tools..."

PACKAGES_TO_INSTALL="node"
[[ "$CONFIGURE_CODEX" == "yes" ]] && PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL codex"
[[ "$CONFIGURE_CLAUDE" == "yes" ]] && PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL claude-code"

brew install $PACKAGES_TO_INSTALL

# ----------------------- Codex Configuration ----------------------------------

if [[ "$CONFIGURE_CODEX" == "yes" ]]; then
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
fi

# ----------------------- Claude Configuration ---------------------------------

if [[ "$CONFIGURE_CLAUDE" == "yes" ]]; then
    gum style --foreground "#00FF00" --bold "Configuring Claude..."

    # Sync Claude dotfiles
    stow claude

    # Enable MCP server for Claude
    gum style --foreground "#00FF00" --bold "Enabling Context7 MCP server for Claude..."
    claude mcp add context7 -- npx -y @upstash/context7-mcp
fi

gum style --foreground "#00FF00" --bold "AI agents configuration complete!"
