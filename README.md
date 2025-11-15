# Dotfiles

Automated macOS system setup and configuration with dotfiles management.

## 📋 Overview

This repository contains automated setup scripts for configuring a new macOS machine with all necessary packages, tools, and personal configurations. It includes:

- Package installation via Homebrew
- Oh-My-Zsh setup with plugins
- Python environment with pyenv
- SSH & GPG key generation and GitHub integration
- AI coding agents configuration (Codex & Claude)
- Dotfiles synchronization using GNU Stow

## 🚀 Quick Start

```bash
# Clone the repository
cd ~
git clone https://github.com/danylomikula/dotfiles.git
cd dotfiles

# Run the bootstrap script
bash bootstrap.sh
```

The script will prompt you for configuration choices throughout the setup process.

## 📦 What Gets Installed

### Development Tools
- **Languages**: Python (latest via pyenv), Node.js, Go
- **Version Control**: Git, GitHub CLI
- **Containers**: Docker, Docker Compose, Colima
- **Kubernetes**: kubectl, kubectx, helm, k9s
- **IaC**: Terraform (tfswitch), Terragrunt, Ansible, Vault
- **CLI Utilities**: jq, fx, yh, htop, iperf3, wget, tree, eza, zoxide, fzf, hugo

### Applications (Casks)
- **Browsers**: Zen Browser
- **Communication**: Signal, Telegram, Slack, Discord
- **Productivity**: Obsidian, Grammarly, Google Drive
- **Development**: Visual Studio Code, Alacritty, Fork, Lens
- **Utilities**: Bartender, AlDente, Maccy, AppCleaner, Shottr, BetterDisplay
- **Security**: Mullvad VPN, Tailscale, GPG Suite

### Terminal Setup
- **Shell**: Zsh with Oh-My-Zsh
- **Prompt**: Starship
- **Multiplexer**: Zellij
- **Terminal**: Alacritty with theme support
- **Fonts**: Nerd Fonts (Hack, Ubuntu Mono, Courier Prime, Fira Code)

### Plugins & Extensions
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-you-should-use
- fast-syntax-highlighting
- zsh-history-substring-search
- zsh-autocomplete

## 🤖 AI Agents Configuration

Optional setup for AI coding assistants with Context7 MCP integration:

- **Codex**: Configured with gpt-5.1-codex model
- **Claude**: Integrated with Context7 for library documentation
- **Features**: Automatic library ID resolution and documentation retrieval

Run separately:
```bash
bash configure-ai-agents.sh
```

## 🔧 Available Scripts

### `bootstrap.sh`
Main setup script that orchestrates the entire installation process.

**Features:**
- Sudo keepalive (no repeated password prompts)
- Interactive configuration with `gum`
- Modular setup blocks
- Error handling and validation

### `configure-git.sh`
Configure Git settings with multiple identities support.

**Options:**
- Global Git configuration
- Personal repository directory with custom identity
- Work repository directory with custom identity
- Global gitignore setup

### `generate-ssh-key.sh`
Generate SSH keys with GitHub integration.

**Options:**
- ED25519 or RSA key types
- Custom key parameters (rounds/length)
- Automatic GitHub key upload via GitHub CLI
- Global SSH key configuration for Git

### `generate-gpg-key.sh`
Generate GPG keys for commit signing.

**Options:**
- ED25519 curve
- Automatic GitHub GPG key upload
- Global signing key configuration
- pinentry-mac integration

### `configure-ai-agents.sh`
Set up AI coding agents with Context7 MCP.

**Installs:**
- Node.js, Codex, Claude Code
- Context7 MCP server
- Custom configuration files

## 📁 Repository Structure

```
dotfiles/
├── bootstrap.sh                 # Main setup script
├── configure-git.sh             # Git configuration
├── generate-ssh-key.sh          # SSH key generation
├── generate-gpg-key.sh          # GPG key generation
├── configure-ai-agents.sh       # AI agents setup
├── alacritty/                   # Alacritty config
├── docker/                      # Docker config
├── git/                         # Git config
├── github-cli/                  # GitHub CLI config
├── k9s/                         # K9s config
├── starship/                    # Starship prompt config
├── zellij/                      # Zellij config
└── zshrc/                       # Zsh configuration
```

## 🔐 Security Features

- **Password Management**: Single sudo password prompt with keepalive
- **SSH Keys**: ED25519 by default with configurable rounds
- **GPG Keys**: ED25519 curve for commit signing
- **GitHub Integration**: Secure authentication via GitHub CLI

## 🎨 Customization

All configuration files are managed via GNU Stow. To modify:

1. Edit files in respective directories
2. Re-run stow: `stow <directory-name>`

Example:
```bash
# Modify Alacritty config
vim alacritty/.config/alacritty/alacritty.toml

# Re-apply
stow alacritty
```

## ⚙️ Configuration Options

### Interactive Prompts
The bootstrap script will ask:
- Git configuration (global, personal, work)
- SSH key generation and GitHub upload
- GPG key generation and GitHub upload
- AI agents configuration

### Non-Interactive Mode
For automated setups, you can skip prompts by pre-configuring or selecting "No" for optional features.

## 🔄 Updates

To update your configuration:

```bash
cd ~/dotfiles
git pull
bash bootstrap.sh  # Re-run for new features
```

Or update specific components:
```bash
# Update AI agents configuration
bash configure-ai-agents.sh

# Regenerate SSH key
bash generate-ssh-key.sh

# Reconfigure Git
bash configure-git.sh
```

## 📝 Notes

- **First Run**: The script will install Homebrew and may take 30-60 minutes
- **Shell Restart**: The script automatically restarts your shell at the end
- **Backup**: Existing configurations are backed up before modification
- **Idempotent**: Safe to run multiple times

## 🐛 Troubleshooting

### Homebrew Issues
```bash
# Reset Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
bash bootstrap.sh
```

### Stow Conflicts
```bash
# Remove conflicting files
rm ~/.zshrc
stow zshrc
```

### Permission Issues
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /opt/homebrew
```

## 🤝 Contributing

Feel free to fork and customize for your needs. Pull requests are welcome!

## 📄 License

MIT License - feel free to use and modify as needed.

## 🔗 Links

- [Homebrew](https://brew.sh/)
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Context7 MCP](https://github.com/upstash/context7-mcp)
