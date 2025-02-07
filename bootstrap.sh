# ------------------------------------------------------------------------------
# System Setup Script (Package Installation, SSH & GPG Configuration)
#
# Version      Date              Author              Info
# 1.0          04-February-2025  Danylo Mikula       Initial Version:
#                                                    - Installs packages, performs system
#                                                      configuration, and includes SSH and
#                                                      GPG key generation and integration.
#
# ------------------------------------------------------------------------------

# ----------------------- Homebrew & Basic Tools -----------------------------

echo "Installing Homebrew..."
export HOMEBREW_NO_ANALYTICS=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing gum..."
brew install gum

# --------------------------- Fonts Installation -----------------------------

gum style --foreground "#00FF00" --bold "Installing fonts..."
brew install --cask font-hack-nerd-font font-ubuntu-mono-nerd-font font-courier-prime font-fira-code-nerd-font

# --------------------------- Oh-My-Zsh Setup ----------------------------------

gum style --foreground "#00FF00" --bold "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

gum style --foreground "#00FF00" --bold "Installing oh-my-zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# --------------------------- Starship Prompt ----------------------------------

gum style --foreground "#00FF00" --bold "Installing starship prompt theme..."
brew install starship

# -------------------- Python Environment (pyenv) ------------------------------

gum style --foreground "#00FF00" --bold "Installing and configuring pyenv and pyenv-virtualenv..."
brew install xz pyenv pyenv-virtualenv
eval "$(pyenv init - zsh)"

LATEST_PYTHON_VERSION=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | grep -v -E 'dev|a|b|rc' | tail -1 | tr -d ' ')
gum style --foreground "#00FF00" --bold "Installing the latest Python version ($LATEST_PYTHON_VERSION) with pyenv..."
pyenv install "$LATEST_PYTHON_VERSION"
pyenv global "$LATEST_PYTHON_VERSION"

# --------------------------- Brew Casks ---------------------------------------

gum style --foreground "#00FF00" --bold "Installing Brew Casks..."
brew install --cask arc telegram slack aldente bartender mullvadvpn tailscale google-drive obsidian grammarly-desktop betterdisplay alacritty visual-studio-code maccy shottr openinterminal bitwarden fork lens

# ----------------------- HashiCorp Repository ---------------------------------

gum style --foreground "#00FF00" --bold "Adding Vault repository to brew..."
brew tap hashicorp/tap

# ---------------------------- CLI Tools ---------------------------------------

gum style --foreground "#00FF00" --bold "Installing CLI tools..."
brew install jq fx yh htop iperf3 make wget speedtest-cli tree eza zoxide stow docker docker-compose docker-buildx colima zellij derailed/k9s/k9s fzf kubernetes-cli kubectx helm terragrunt warrensbox/tap/tfswitch awscli hashicorp/tap/vault argocd ansible

# ---------------------- Dotfiles Synchronization ------------------------------
gum style --foreground "#00FF00" --bold "Synchronizing dotfiles..."
# WARNING: This removes your current ~/.zshrc. Ensure your dotfiles repository is complete.
rm ~/.zshrc
stow zshrc starship alacritty zellij k9s docker

# ------------------------- Alacritty Themes -----------------------------------

gum style --foreground "#00FF00" --bold "Installing Alacritty themes..."
ALACRITTY_THEMES_DIR="$HOME/.config/alacritty/themes"
if [ ! -d "$ALACRITTY_THEMES_DIR" ]; then
  gum style --foreground "#00FF00" --bold "Cloning alacritty-theme into $ALACRITTY_THEMES_DIR..."
  git clone https://github.com/alacritty/alacritty-theme "$ALACRITTY_THEMES_DIR"
else
  gum style --foreground "#FFFF00" --bold "Alacritty themes directory already exists, skipping clone."
fi

# --------------------- Git Configuration Script ----------------------

# Ask the user if they want to configure Git
gum style --foreground "#00FF00" --bold "Do you want to configure Git?"
GIT_CONFIG_CHOICE=$(gum choose "Yes" "No")
if [ "$GIT_CONFIG_CHOICE" = "Yes" ]; then

  # -------------------- Global Git Configuration Setup ------------------------
  gum style --foreground "#00FF00" --bold "Global Git Configuration Setup"

  # Prompt for global user.name and user.email
  GLOBAL_NAME=$(gum input --placeholder "Enter your global git user.name")
  GLOBAL_EMAIL=$(gum input --placeholder "Enter your global git user.email")

  # Prompt for default branch with default value "main"
  DEFAULT_BRANCH=$(gum input --placeholder "Enter default branch name (default: main)")
  if [ -z "$DEFAULT_BRANCH" ]; then
    DEFAULT_BRANCH="main"
  fi

  # Prompt for core editor with default value "nano"
  CORE_EDITOR=$(gum input --placeholder "Enter core editor (default: nano)")
  if [ -z "$CORE_EDITOR" ]; then
    CORE_EDITOR="nano"
  fi

  # Prompt for branch sorting order with default value "-committerdate"
  BRANCH_SORT=$(gum input --placeholder "Enter branch sort order (default: -committerdate)")
  if [ -z "$BRANCH_SORT" ]; then
    BRANCH_SORT="-committerdate"
  fi

  # Prompt for column UI with default value "auto"
  COLUMN_UI=$(gum input --placeholder "Enter column.ui value (default: auto)")
  if [ -z "$COLUMN_UI" ]; then
    COLUMN_UI="auto"
  fi

  # Apply the global configuration
  git config --global user.name "$GLOBAL_NAME"
  git config --global user.email "$GLOBAL_EMAIL"
  git config --global init.defaultBranch "$DEFAULT_BRANCH"
  git config --global core.editor "$CORE_EDITOR"
  git config --global branch.sort "$BRANCH_SORT"
  git config --global column.ui "$COLUMN_UI"

  gum style --foreground "#00FF00" --bold "Global .gitconfig settings have been applied."

  # ----------------- Optional: Create Personal Repository Directory --------------
  gum style --foreground "#00FF00" --bold "Do you want to create a personal repository directory?"
  CREATE_PERSONAL=$(gum choose "Yes" "No")
  if [ "$CREATE_PERSONAL" = "Yes" ]; then
    PERSONAL_DIR=$(gum input --placeholder "Enter path for personal repositories (default: ~/git/personal)")
    if [ -z "$PERSONAL_DIR" ]; then
      PERSONAL_DIR="$HOME/git/personal"
    fi
    mkdir -p "$PERSONAL_DIR"
    gum style --foreground "#00FF00" --bold "Personal repository directory set to $PERSONAL_DIR"
    
    # Prompt for the personal git email; if blank, use GLOBAL_EMAIL and notify the user.
    PERSONAL_EMAIL=$(gum input --placeholder "Enter your personal git email (default: $GLOBAL_EMAIL)")
    if [ -z "$PERSONAL_EMAIL" ]; then
      PERSONAL_EMAIL="$GLOBAL_EMAIL"
      gum style --foreground "#FFFF00" --bold "No personal email provided. Using global email: $GLOBAL_EMAIL"
    fi

    # Prompt for the personal user.name; if blank, use GLOBAL_NAME and notify the user.
    PERSONAL_NAME=$(gum input --placeholder "Enter your personal git user.name (default: $GLOBAL_NAME)")
    if [ -z "$PERSONAL_NAME" ]; then
      PERSONAL_NAME="$GLOBAL_NAME"
      gum style --foreground "#FFFF00" --bold "No personal user.name provided. Using global user.name: $GLOBAL_NAME"
    fi

    # Create a .gitconfig file in the personal directory with the [user] section
    cat > "$PERSONAL_DIR/.gitconfig" <<EOF
[user]
    name = $PERSONAL_NAME
    email = $PERSONAL_EMAIL
EOF
    gum style --foreground "#00FF00" --bold "Created $PERSONAL_DIR/.gitconfig with your personal settings."
    
    # Add an includeIf directive to the global .gitconfig for personal repositories
    git config --global --add includeIf."gitdir:$PERSONAL_DIR/**".path "$PERSONAL_DIR/.gitconfig"
    gum style --foreground "#00FF00" --bold "Global .gitconfig updated to include personal repositories from $PERSONAL_DIR."
  fi

  # ------------------ Optional: Create Work Repository Directory ----------------
  gum style --foreground "#00FF00" --bold "Do you want to create a work repository directory?"
  CREATE_WORK=$(gum choose "Yes" "No")
  if [ "$CREATE_WORK" = "Yes" ]; then
    WORK_DIR=$(gum input --placeholder "Enter path for work repositories (default: ~/git/work)")
    if [ -z "$WORK_DIR" ]; then
      WORK_DIR="$HOME/git/work"
    fi
    mkdir -p "$WORK_DIR"
    gum style --foreground "#00FF00" --bold "Work repository directory set to $WORK_DIR"
    
    # Prompt for the work git email; if blank, use GLOBAL_EMAIL and notify the user.
    WORK_EMAIL=$(gum input --placeholder "Enter your work git email (default: $GLOBAL_EMAIL)")
    if [ -z "$WORK_EMAIL" ]; then
      WORK_EMAIL="$GLOBAL_EMAIL"
      gum style --foreground "#FFFF00" --bold "No work email provided. Using global email: $GLOBAL_EMAIL"
    fi

    # Prompt for the work user.name; if blank, use GLOBAL_NAME and notify the user.
    WORK_NAME=$(gum input --placeholder "Enter your work git user.name (default: $GLOBAL_NAME)")
    if [ -z "$WORK_NAME" ]; then
      WORK_NAME="$GLOBAL_NAME"
      gum style --foreground "#FFFF00" --bold "No work user.name provided. Using global user.name: $GLOBAL_NAME"
    fi

    # Create a .gitconfig file in the work directory with the [user] section
    cat > "$WORK_DIR/.gitconfig" <<EOF
[user]
    name = $WORK_NAME
    email = $WORK_EMAIL
EOF
    gum style --foreground "#00FF00" --bold "Created $WORK_DIR/.gitconfig with your work settings."
    
    # Add an includeIf directive to the global .gitconfig for work repositories
    git config --global --add includeIf."gitdir:$WORK_DIR/**".path "$WORK_DIR/.gitconfig"
    gum style --foreground "#00FF00" --bold "Global .gitconfig updated to include work repositories from $WORK_DIR."
  fi

  # ------------------ Optional: Global gitignore Configuration ------------------

  gum style --foreground "#00FF00" --bold "Do you want to configure a global gitignore file?"
  GITIGNORE_CHOICE=$(gum choose "Yes" "No")
  if [ "$GITIGNORE_CHOICE" = "Yes" ]; then
    GITIGNORE_PATH=$(gum input --placeholder "Enter the path for your global gitignore file (default: ~/.gitignore)")
    if [ -z "$GITIGNORE_PATH" ]; then
      GITIGNORE_PATH="$HOME/.gitignore"
      gum style --foreground "#FFFF00" --bold "No path provided. Using default: $GITIGNORE_PATH"
    fi
    git config --global core.excludesfile "$GITIGNORE_PATH"
    gum style --foreground "#00FF00" --bold "Global gitignore file set to $GITIGNORE_PATH."
    
    # Check if the file exists; if not, create an empty file and notify the user.
    if [ ! -f "$GITIGNORE_PATH" ]; then
      touch "$GITIGNORE_PATH"
      gum style --foreground "#FFFF00" --bold "The file $GITIGNORE_PATH did not exist. An empty file has been created. Please update this file with your ignore patterns."
    fi
  fi

  gum style --foreground "#00FF00" --bold "Git configuration complete."

else
  gum style --foreground "#FFFF00" --bold "Skipping Git configuration."
fi


# --------------------- SSH Key Generation & Configuration ----------------------

gum style --foreground "#00FF00" --bold "Do you want to generate an SSH key?"
SSH_CHOICE=$(gum choose "Yes" "No")
if [ "$SSH_CHOICE" = "Yes" ]; then
  # Ask for SSH key comment (-C)
  SSH_COMMENT=$(gum input --placeholder "Enter SSH key comment (default: $(whoami)@$(hostname))")
  if [ -z "$SSH_COMMENT" ]; then
    SSH_COMMENT="$(whoami)@$(hostname)"
  fi

  # Ask for SSH key type (-t) via gum choose (ed25519 or rsa)
  gum style --foreground "#00FF00" --bold "Select SSH key type (default: ed25519):"
  SSH_TYPE=$(gum choose "ed25519" "rsa")
  
  if [ "$SSH_TYPE" = "rsa" ]; then
    SSH_LENGTH=$(gum input --placeholder "Enter key length (default: 4096)")
    if [ -z "$SSH_LENGTH" ]; then
      SSH_LENGTH="4096"
    fi
    DEFAULT_SSH_FILE="$HOME/.ssh/id_rsa"
  else
    SSH_ROUNDS=$(gum input --placeholder "Enter number of rounds (default: 100)")
    if [ -z "$SSH_ROUNDS" ]; then
      SSH_ROUNDS="100"
    fi
    DEFAULT_SSH_FILE="$HOME/.ssh/id_ed25519"
  fi

  # Ask for file path to save the key (-f) with default value
  SSH_FILE=$(gum input --placeholder "Enter file path to save key (default: $DEFAULT_SSH_FILE)")
  if [ -z "$SSH_FILE" ]; then
    SSH_FILE="$DEFAULT_SSH_FILE"
  fi

  # If file exists, append a timestamp to avoid overwriting
  if [ -f "$SSH_FILE" ]; then
    TIMESTAMP=$(date +%s)
    SSH_FILE="${SSH_FILE}_${TIMESTAMP}"
  fi

  gum style --foreground "#00FF00" --bold "Generating SSH key..."
  if [ "$SSH_TYPE" = "rsa" ]; then
    ssh-keygen -t rsa -b "$SSH_LENGTH" -C "$SSH_COMMENT" -f "$SSH_FILE" || {
      gum style --foreground "#FF0000" --bold "SSH key generation failed."; exit 1;
    }
  else
    ssh-keygen -t ed25519 -a "$SSH_ROUNDS" -C "$SSH_COMMENT" -f "$SSH_FILE" || {
      gum style --foreground "#FF0000" --bold "SSH key generation failed."; exit 1;
    }
  fi

  PUB_FILE="${SSH_FILE}.pub"
  if [ -f "$PUB_FILE" ]; then
    gum style --foreground "#00FF00" --bold "Your SSH public key is:"
    cat "$PUB_FILE"
  else
    gum style --foreground "#FF0000" --bold "Public key file not found."
  fi

  # Ask if user wants to add this SSH key to GitHub
  gum style --foreground "#00FF00" --bold "Do you want to add this SSH key to GitHub?"
  ADD_TO_GITHUB=$(gum choose "Yes" "No")
  if [ "$ADD_TO_GITHUB" = "Yes" ]; then
    gum style --foreground "#00FF00" --bold "Installing GitHub CLI..."
    brew install gh
    gum style --foreground "#00FF00" --bold "Logging into GitHub CLI..."
    gh auth login -s admin:public_key

    SSH_KEY_TITLE=$(gum input --placeholder "Enter a title for your new SSH key")
    if [ -z "$SSH_KEY_TITLE" ]; then
      SSH_KEY_TITLE="SSH Key $(date +%Y%m%d%H%M%S)"
    fi

    gum style --foreground "#00FF00" --bold "Adding your SSH key to GitHub..."
    gh ssh-key add "$PUB_FILE" --title "$SSH_KEY_TITLE"
  else
    gum style --foreground "#FFFF00" --bold "Skipping adding SSH key to GitHub."
  fi

  # Ask if user wants to set this key as the global SSH key for git
  gum style --foreground "#00FF00" --bold "Do you want to set this SSH key as your global SSH key for git?"
  SET_GLOBAL=$(gum choose "Yes" "No")
  if [ "$SET_GLOBAL" = "Yes" ]; then
    git config --global core.sshCommand "ssh -i $SSH_FILE"
    gum style --foreground "#00FF00" --bold "Global SSH key set to $SSH_FILE."
  else
    gum style --foreground "#FFFF00" --bold "Skipping setting global SSH key."
  fi
else
  gum style --foreground "#FFFF00" --bold "Skipping SSH key generation."
fi

# --------------------- GPG Key Generation & Configuration ----------------------

gum style --foreground "#00FF00" --bold "Do you want to generate a GPG key?"
GPG_CHOICE=$(gum choose "Yes" "No")
if [ "$GPG_CHOICE" = "Yes" ]; then
  # Ask for GPG details using gum input.
  GPG_PASSWORD=$(gum input --password --placeholder "Enter GPG key password")
  GPG_OWNER_NAME=$(gum input --placeholder "Enter GPG key owner name")
  GPG_OWNER_EMAIL=$(gum input --placeholder "Enter GPG key owner email")

  gum style --foreground "#00FF00" --bold "Installing gnupg and pinentry-mac..."
  brew install gnupg pinentry-mac

  EXISTING_KEYS=$(gpg --list-secret-keys --keyid-format=long | awk '/^sec/ {print $2}' | cut -d'/' -f2)

  gum style --foreground "#00FF00" --bold "Generating GPG key..."
  GPG_BATCH_FILE=$(mktemp)
  cat > "$GPG_BATCH_FILE" <<EOF
%echo Generating a GPG key
Key-Type: eddsa
Key-Curve: ed25519
Subkey-Type: ecdh
Subkey-Curve: cv25519
Name-Real: ${GPG_OWNER_NAME}
Name-Email: ${GPG_OWNER_EMAIL}
Expire-Date: 0
Passphrase: ${GPG_PASSWORD}
%commit
%echo done
EOF
  gpg --batch --gen-key "$GPG_BATCH_FILE"
  rm "$GPG_BATCH_FILE"

  if [ ! -d "$HOME/.gnupg" ]; then
    gum style --foreground "#FFFF00" --bold "Directory ~/.gnupg does not exist. Creating it..."
    mkdir -p "$HOME/.gnupg"
  fi
  if [ -f "$HOME/.gnupg/gpg-agent.conf" ]; then
    if ! grep -q "pinentry-program" "$HOME/.gnupg/gpg-agent.conf"; then
      echo "pinentry-program $(which pinentry-mac)" >> "$HOME/.gnupg/gpg-agent.conf"
    fi
  else
    echo "pinentry-program $(which pinentry-mac)" > "$HOME/.gnupg/gpg-agent.conf"
  fi
  killall gpg-agent 2>/dev/null || true
  gum style --foreground "#00FF00" --bold "GPG key generation and configuration complete."

  ALL_KEYS=$(gpg --list-secret-keys --keyid-format=long | awk '/^sec/ {print $2}' | cut -d'/' -f2)
  EXISTING_SORTED=$(mktemp)
  ALL_SORTED=$(mktemp)
  echo "$EXISTING_KEYS" | sort > "$EXISTING_SORTED"
  echo "$ALL_KEYS" | sort > "$ALL_SORTED"
  NEW_KEY=$(comm -13 "$EXISTING_SORTED" "$ALL_SORTED")
  rm "$EXISTING_SORTED" "$ALL_SORTED"
  if [ -z "$NEW_KEY" ]; then
    gum style --foreground "#FF0000" --bold "Failed to generate a new GPG key."
    exit 1
  fi
  KEY_ID="$NEW_KEY"
  prefix=$(gum style --foreground "#00FF00" --bold "Your GPG key ID is: " | tr -d '\n')
  key=$(gum style --foreground "#800080" --bold "$KEY_ID" | tr -d '\n')
  echo "$prefix$key"
  gum style --foreground "#00FF00" --bold "Exporting your GPG public key in ASCII armor format..."
  gpg --armor --export "$KEY_ID"

  gum style --foreground "#00FF00" --bold "Do you want to set this new key as your global signing key in git?"
  SET_GLOBAL=$(gum choose "Yes" "No")
  if [ "$SET_GLOBAL" = "Yes" ]; then
    git config --global user.signingkey "$KEY_ID"
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true
    gum style --foreground "#00FF00" --bold "Global signing key set to $KEY_ID."
  else
    gum style --foreground "#FFFF00" --bold "Skipping setting global signing key."
  fi

  gum style --foreground "#00FF00" --bold "Do you want to add this GPG key to GitHub?"
  ADD_TO_GITHUB=$(gum choose "Yes" "No")
  if [ "$ADD_TO_GITHUB" = "Yes" ]; then
    gum style --foreground "#00FF00" --bold "Installing GitHub CLI..."
    brew install gh
    gum style --foreground "#00FF00" --bold "Logging into GitHub CLI..."
    gh auth login -s write:gpg_key
    GPG_KEY_TITLE=$(gum input --placeholder "Enter a title for your new GPG key")
    TMP_GPG_KEY=$(mktemp)
    gpg --armor --export "$KEY_ID" > "$TMP_GPG_KEY"
    gum style --foreground "#00FF00" --bold "Adding your GPG key to GitHub..."
    gh gpg-key add "$TMP_GPG_KEY" --title "$GPG_KEY_TITLE"
    rm "$TMP_GPG_KEY"
  else
    gum style --foreground "#FFFF00" --bold "Skipping adding GPG key to GitHub."
  fi
else
  gum style --foreground "#FFFF00" --bold "Skipping GPG key generation."
fi

# -------------------------- Final Step: Restart Shell -------------------------
gum style --foreground "#00FF00" --bold "Restarting shell..."
exec zsh
