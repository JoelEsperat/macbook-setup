#!/bin/zsh
set -euo pipefail

if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# SUDO
echo "Configuring sudoers..."
sudo install -o root -g wheel -m 0440 "$(dirname "$0")/sudoers.d/joel" /private/etc/sudoers.d/joel
sudo visudo -c >/dev/null

# Hosts
echo "Configuring hosts..."
if [ -f "/etc/hosts" ] && [ ! -f "/etc/hosts.bak" ]; then
  sudo cp /etc/hosts /etc/hosts.bak
fi
sudo install -o root -g wheel -m 0644 "$(dirname "$0")/etc/hosts" /etc/hosts

# Static routes
echo "Configuring static routes..."
if networksetup -listallnetworkservices | grep -Fxq "Wi-Fi"; then
  sudo networksetup -setadditionalroutes Wi-Fi \
    192.168.1.0 255.255.255.0 192.168.0.210
else
  echo "Warning: 'Wi-Fi' network service not found. Skipping static routes configuration."
fi

# SSH
echo "Configuring SSH..."
mkdir -p "$HOME/.ssh"
if [ -f "$HOME/.ssh/config" ] && [ ! -f "$HOME/.ssh/config.bak" ]; then
  cp "$HOME/.ssh/config" "$HOME/.ssh/config.bak"
fi
if [ -f "$HOME/.ssh/known_hosts" ] && [ ! -f "$HOME/.ssh/known_hosts.bak" ]; then
  cp "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts.bak"
fi
cp -f "$(dirname "$0")/ssh/config" "$HOME/.ssh/"
cp -f "$(dirname "$0")/ssh/known_hosts" "$HOME/.ssh/"

# Git
echo "Configuring Git..."
if [ -f "$HOME/.gitconfig" ] && [ ! -f "$HOME/.gitconfig.bak" ]; then
  cp "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
fi
cp -f "$(dirname "$0")/git/gitconfig" "$HOME/.gitconfig"

# ZSH
echo "Configuring ZSH..."
install -m 0644 "$(dirname "$0")/zsh/zshrc" "$HOME/.zshrc-extra"
install -m 0644 "$(dirname "$0")/zsh/zprofile" "$HOME/.zprofile-extra"
touch "$HOME/.zshrc" "$HOME/.zprofile"
SRC_ZSHRC="if [ -f \"$HOME/.zshrc-extra\" ]; then source \"$HOME/.zshrc-extra\"; fi"
grep -qF -- "$SRC_ZSHRC" "$HOME/.zshrc" || echo "$SRC_ZSHRC" >> "$HOME/.zshrc"
SRC_ZPROFILE="if [ -f \"$HOME/.zprofile-extra\" ]; then source \"$HOME/.zprofile-extra\"; fi"
grep -qF -- "$SRC_ZPROFILE" "$HOME/.zprofile" || echo "$SRC_ZPROFILE" >> "$HOME/.zprofile"

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

# Apply macOS settings
# echo "Applying macOS settings..."
# "$(dirname "$0")/setup-macos.sh"

echo "Setup complete!"
