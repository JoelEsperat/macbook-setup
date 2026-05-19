#!/bin/zsh
set -euo pipefail

if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew"
  true | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Load Homebrew environment again after installing
  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Exit if, for some reason, Homebrew is not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew failed to install"
  exit 1
fi

echo "Updating Homebrew"
brew doctor || true
brew update

echo "Installing Homebrew packages from Brewfile"
brew bundle install --file "$(dirname "$0")/Brewfile"

# Cleanup
echo "Cleaning up Homebrew"
brew cleanup

# Remove Google Docs, Slides, and Sheets if they exist
for app in "Google Docs.app" "Google Slides.app" "Google Sheets.app"; do
  if [[ -d "/Applications/$app" ]]; then
    echo "Removing $app"
    sudo rm -rf "/Applications/$app"
  fi
done

# Install Python packages
pipx_bin="$(command -v pipx || true)"
if [ -z "$pipx_bin" ]; then
  pipx_bin="/opt/homebrew/bin/pipx"
fi
"$pipx_bin" install --force ffmpeg-quality-metrics
"$pipx_bin" ensurepath

