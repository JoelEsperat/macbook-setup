#!/bin/zsh

# Install Homebrew if needed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew"
  true | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Exit if, for some reason, Homebrew is not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew failed to install"
  return 1
fi

echo "Updating Homebrew"
brew doctor
brew update

# Homebrew recipes
recipes=(
  ca-certificates
  cheat
  coreutils
  exiftool
  ffmpeg
  gemini-cli
  git
  mactop
  mas
  media-info
  mozjpeg
  ollama
  python
  rclone
  rsync
  tlrc
  tmux
  wget
  zsh-autocomplete
)

# Install Homebrew recipes
brew install --quiet "${recipes[@]}"

# Homebrew casks
casks=(
  google-chrome
  google-drive
  handbrake
  raspberry-pi-imager
  visual-studio-code
  vlc
)

# Install Homebrew casks
brew install --quiet --cask "${casks[@]}"

# Cleanup
echo "Cleaning up Homebrew"
brew cleanup

# Remove Google Docs, Slides, and Sheets if they exist
if [[ -d "/Applications/Google Docs.app" ]]; then
  echo "Removing Google Docs"
  sudo rm -rf "/Applications/Google Docs.app"
fi
if [[ -d "/Applications/Google Slides.app" ]]; then
  echo "Removing Google Slides"
  sudo rm -rf "/Applications/Google Slides.app"
fi
if [[ -d "/Applications/Google Sheets.app" ]]; then
  echo "Removing Google Sheets"
  sudo rm -rf "/Applications/Google Sheets.app"
fi

# Install Python packages
pipx install ffmpeg-quality-metrics
pipx ensurepath

# Mac App Store apps
mas upgrade
mas_apps=(
  1451544217 # Lightroom
  310633997  # WhatsApp
  1295203466 # Windows
)

# Install Mac App Store apps
mas install "${mas_apps[@]}"
