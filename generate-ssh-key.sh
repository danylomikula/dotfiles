# ------------------------------------------------------------------------------
# SSH Key Generation Script
#
# Version      Date              Author              Info
# 1.0          04-February-2025  Danylo Mikula       Initial Version:
#                                                    - Interactively generates an SSH key,
#                                                      optionally adds it to GitHub, and
#                                                      sets it as the global SSH key in git.
#
# ------------------------------------------------------------------------------

# --- SSH KEY GENERATION & CONFIGURATION BLOCK ---

echo "Installing gum..."
brew install gum

# Ask the user if they want to generate an SSH key
gum style --foreground "#00FF00" --bold "Do you want to generate an SSH key?"
SSH_CHOICE=$(gum choose "Yes" "No")

if [ "$SSH_CHOICE" = "Yes" ]; then
  # Ask for SSH key comment (-C)
  SSH_COMMENT=$(gum input --placeholder "Enter SSH key comment (default: $(whoami)@$(hostname))")
  if [ -z "$SSH_COMMENT" ]; then
    SSH_COMMENT="$(whoami)@$(hostname)"
  fi

  # Ask for SSH key type (-t), default is ed25519
  gum style --foreground "#00FF00" --bold "Select SSH key type (default: ed25519):"
  SSH_TYPE=$(gum choose "ed25519" "rsa")

  # For RSA, ask for key length (-b) with default 4096; for ed25519, ask for rounds (-a) with default 100.
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

  # Ask for file path to save the key (-f) with a default value
  SSH_FILE=$(gum input --placeholder "Enter file path to save key (default: $DEFAULT_SSH_FILE)")
  if [ -z "$SSH_FILE" ]; then
    SSH_FILE="$DEFAULT_SSH_FILE"
  fi

  # If the file already exists, append a timestamp to avoid overwriting
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

  # Determine the public key file (typically <private_key>.pub)
  PUB_FILE="${SSH_FILE}.pub"
  if [ -f "$PUB_FILE" ]; then
    gum style --foreground "#00FF00" --bold "Your SSH public key is:"
    cat "$PUB_FILE"
  else
    gum style --foreground "#FF0000" --bold "Public key file not found."
  fi

  # Ask if the user wants to add this SSH key to GitHub
  gum style --foreground "#00FF00" --bold "Do you want to add this SSH key to GitHub?"
  ADD_TO_GITHUB=$(gum choose "Yes" "No")
  if [ "$ADD_TO_GITHUB" = "Yes" ]; then
    gum style --foreground "#00FF00" --bold "Installing GitHub CLI..."
    brew install gh
    gum style --foreground "#00FF00" --bold "Logging into GitHub CLI..."
    gh auth login -s admin:public_key

    # Ask for a title for the new SSH key
    SSH_KEY_TITLE=$(gum input --placeholder "Enter a title for your new SSH key")
    if [ -z "$SSH_KEY_TITLE" ]; then
      SSH_KEY_TITLE="SSH Key $(date +%Y%m%d%H%M%S)"
    fi

    gum style --foreground "#00FF00" --bold "Adding your SSH key to GitHub..."
    gh ssh-key add "$PUB_FILE" --title "$SSH_KEY_TITLE"
  else
    gum style --foreground "#FFFF00" --bold "Skipping adding SSH key to GitHub."
  fi

  # Ask if the user wants to set this new key as the global SSH key for git
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
