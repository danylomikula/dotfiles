# ------------------------------------------------------------------------------
# GPG Key Generation Script
#
# Version      Date              Author              Info
# 1.0          04-February-2025  Danylo Mikula      Initial Version:
#                                                    - Interactively generates a GPG key,
#                                                      optionally adds it to GitHub.
#
# ------------------------------------------------------------------------------

# --- GPG KEY GENERATION & CONFIGURATION BLOCK ---

echo "Installing gum..."
brew install gum

# Ask the user if they want to generate a GPG key using gum choose
gum style --foreground "#00FF00" --bold "Do you want to generate a GPG key?"
CHOICE=$(gum choose "Yes" "No")

if [ "$CHOICE" = "Yes" ]; then
  # Ask for GPG details using gum input.
  GPG_PASSWORD=$(gum input --password --placeholder "Enter GPG key password")
  GPG_OWNER_NAME=$(gum input --placeholder "Enter GPG key owner name")
  GPG_OWNER_EMAIL=$(gum input --placeholder "Enter GPG key owner email")

  # Install gnupg and pinentry-mac
  gum style --foreground "#00FF00" --bold "Installing gnupg and pinentry-mac..."
  brew install gnupg pinentry-mac

  # Capture the list of existing key IDs before generating a new key.
  EXISTING_KEYS=$(gpg --list-secret-keys --keyid-format=long \
    | awk '/^sec/ {print $2}' | cut -d'/' -f2)

  gum style --foreground "#00FF00" --bold "Generating GPG key..."

  # Create a temporary file for the GPG batch configuration.
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

  # Generate the GPG key in batch mode.
  gpg --batch --gen-key "$GPG_BATCH_FILE"
  rm "$GPG_BATCH_FILE"

  # Configure GPG agent to use pinentry-mac.
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

  # Capture the list of key IDs after generating the new key.
  ALL_KEYS=$(gpg --list-secret-keys --keyid-format=long \
    | awk '/^sec/ {print $2}' | cut -d'/' -f2)

  # Use temporary files to sort and compare the keys.
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

  # Set KEY_ID to the new key.
  KEY_ID="$NEW_KEY"

  # Display the key ID with a colored prefix in green and the key in purple.
  prefix=$(gum style --foreground "#00FF00" --bold "Your GPG key ID is: " | tr -d '\n')
  key=$(gum style --foreground "#800080" --bold "$KEY_ID" | tr -d '\n')
  echo "$prefix$key"

  # Export the new GPG key in ASCII armor format.
  gum style --foreground "#00FF00" --bold "Exporting your GPG public key in ASCII armor format..."
  gpg --armor --export "$KEY_ID"

  # --- Ask if you want to set this new key as your global signing key in git ---
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

  # Ask the user if they want to add the new GPG key to GitHub.
  gum style --foreground "#00FF00" --bold "Do you want to add this GPG key to GitHub?"
  ADD_TO_GITHUB=$(gum choose "Yes" "No")
  if [ "$ADD_TO_GITHUB" = "Yes" ]; then
    gum style --foreground "#00FF00" --bold "Installing GitHub CLI..."
    brew install gh
    gum style --foreground "#00FF00" --bold "Logging into GitHub CLI..."
    gh auth login -s write:gpg_key

    # Ask for a title for the new GPG key.
    GPG_KEY_TITLE=$(gum input --placeholder "Enter a title for your new GPG key")

    # Save the exported key to a temporary file.
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
