# ------------------------------------------------------------------------------
# Git Configuration Script
#
# Version      Date              Author              Info
# 1.0          04-February-2025  Danylo Mikula       Initial Version:
#                                                    - Configures global .gitconfig settings.
#                                                    - Optionally creates separate directories for
#                                                      personal and work repositories and sets up
#                                                      includeIf directives.
#
# ------------------------------------------------------------------------------

echo "Installing gum..."
brew install gum

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
