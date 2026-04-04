#!/bin/zsh

# SUDO
echo "Configuring sudoers..."
sudo cp "$(dirname "$0")/sudoers.d/joel" /private/etc/sudoers.d/joel

# Hosts
echo "\nConfiguring hosts..."
sudo cp "$(dirname "$0")/etc/hosts" /etc/hosts

# SSH
echo "\nConfiguring SSH..."
if [ -d "$HOME/.ssh" ]; then rm -rf "$HOME/.ssh"; fi
cp -R "$(dirname "$0")/ssh" ~/.ssh
ln -s ~/.credentials/ssh/id_ed25519 ~/.ssh/id_ed25519

# ZSH
echo "\nConfiguring ZSH..."
cp "$(dirname "$0")/zsh/zshrc" ~/.zshrc-extra
cp "$(dirname "$0")/zsh/zprofile" ~/.zprofile-extra
SRC_ZSHRC="if [ -f \"$HOME/.zshrc-extra\" ]; then source \"$HOME/.zshrc-extra\"; fi"
grep -qF -- "$SRC_ZSHRC" ~/.zshrc || echo "$SRC_ZSHRC" >> ~/.zshrc
SRC_ZPROFILE="if [ -f \"$HOME/.zprofile-extra\" ]; then source \"$HOME/.zprofile-extra\"; fi"
grep -qF -- "$SRC_ZPROFILE" ~/.zprofile || echo "$SRC_ZPROFILE" >> ~/.zprofile
source ~/.zshrc
source ~/.zprofile

# Install or update apps
echo "\nInstalling applications..."
"$(dirname "$0")/setup-apps.sh"

# Install custom scripts
echo "\nInstalling custom scripts..."
cp "$(dirname "$0")/bin/backup-nas-to-samsung-usb.sh" ~/.local/bin/backup-nas-to-samsung-usb.sh
chmod +x ~/.local/bin/*.sh

# Deploy credentials
echo "\nDeploying credentials..."
SYNC_METHOD="/opt/homebrew/bin/rsync"
SYNC_ARGS=(-avh --delete)
SOURCE="joel@nas:/data/.credentials/"
TARGET="/Users/joel/.credentials/"
mkdir -p "$TARGET"
"$SYNC_METHOD" "${SYNC_ARGS[@]}" "$SOURCE" "$TARGET"

# Apply macOS settings
#echo "\nApplying macOS settings..."
#"$(dirname "$0")/setup-macos.sh"

echo "\nSetup complete!"
