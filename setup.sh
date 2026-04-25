#!/bin/zsh
set -euo pipefail

# SUDO
echo "Configuring sudoers..."
sudo install -o root -g wheel -m 0440 "$(dirname "$0")/sudoers.d/joel" /private/etc/sudoers.d/joel
sudo visudo -c >/dev/null

# Hosts
echo "Configuring hosts..."
sudo install -o root -g wheel -m 0644 "$(dirname "$0")/etc/hosts" /etc/hosts

# SSH
echo "Configuring SSH..."
mkdir -p "$HOME/.ssh"
cp -f "$(dirname "$0")/ssh/config" "$HOME/.ssh/"
# Link the key if it exists
if [ -f "$HOME/.credentials/ssh/id_ed25519" ]; then
    ln -sf "$HOME/.credentials/ssh/id_ed25519" "$HOME/.ssh/id_ed25519"
else
    echo "Warning: SSH key not found in credentials"
fi

# ZSH
echo "Configuring ZSH..."
install -m 0644 "$(dirname "$0")/zsh/zshrc" "$HOME/.zshrc-extra"
install -m 0644 "$(dirname "$0")/zsh/zprofile" "$HOME/.zprofile-extra"
SRC_ZSHRC="if [ -f \"$HOME/.zshrc-extra\" ]; then source \"$HOME/.zshrc-extra\"; fi"
grep -qF -- "$SRC_ZSHRC" "$HOME/.zshrc" || echo "$SRC_ZSHRC" >> "$HOME/.zshrc"
SRC_ZPROFILE="if [ -f \"$HOME/.zprofile-extra\" ]; then source \"$HOME/.zprofile-extra\"; fi"
grep -qF -- "$SRC_ZPROFILE" "$HOME/.zprofile" || echo "$SRC_ZPROFILE" >> "$HOME/.zprofile"
source "$HOME/.zshrc"
source "$HOME/.zprofile"

# Install or update apps
echo "Installing applications..."
"$(dirname "$0")/setup-apps.sh"

# Install custom scripts
echo "Installing custom scripts..."
mkdir -p "$HOME/.local/bin"
for script in "$(dirname "$0")/bin"/*.sh; do
  cp "$script" "$HOME/.local/bin/"
done
chmod +x "$HOME/.local/bin"/*.sh

# Deploy credentials
echo "Deploying credentials..."
SYNC_METHOD="$(command -v rsync || true)"
if [ -z "$SYNC_METHOD" ]; then
  SYNC_METHOD="/opt/homebrew/bin/rsync"
fi
SYNC_ARGS=(-avh --delete)
SOURCE="joel@nas:/data/credentials/"
TARGET="$HOME/.credentials/"
mkdir -p "$TARGET"
"$SYNC_METHOD" "${SYNC_ARGS[@]}" "$SOURCE" "$TARGET"

# Apply macOS settings
# echo "Applying macOS settings..."
# "$(dirname "$0")/setup-macos.sh"

echo "Setup complete!"
