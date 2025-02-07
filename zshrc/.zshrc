# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Custom $PATH with extra locations
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Disable Homebrew Analytics
export HOMEBREW_NO_ANALYTICS=1

# Load Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# Update oh-my-zsh Settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Enable Plugins
plugins=(
git
terraform
kubectl
helm
pyenv
zsh-autosuggestions
zsh-syntax-highlighting
fast-syntax-highlighting
zsh-autocomplete
you-should-use
)

source $ZSH/oh-my-zsh.sh

# Configure eza alias
alias ls="eza --icons=always"

# Load zoxide and configure alias
alias cd="z"
eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Initialize starship
eval "$(starship init zsh)"

# Autostart a new zellij shell
eval "$(zellij setup --generate-auto-start zsh)"
