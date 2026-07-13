# macbook-setup

Personal MacBook configuration as code. Installs/updates apps, configures ZSH, and SSH config.

## What it does

- **`setup.sh`** — entry point
- **`setup-apps.sh`** — installs/updates package manager (homebrew) and applications
- **`sudoers.d/`** — passwordless sudo
- **`etc/hosts`** — local network hostname aliases
- **`ssh/config`** — SSH config for homelab machines
- **`git/gitconfig`** — global Git configuration
- **`zsh/zshrc`** — aliases, autocomplete
- **`zsh/zprofile`** — photos and videos utility functions
- **`bin/`** — utility scripts installed to `~/.local/bin`

Credentials (such as SSH private keys) must be managed and deployed manually.

## Usage

```sh
git clone https://github.com/JoelEsperat/macbook-setup.git ~/Projects/macbook-setup
~/Projects/macbook-setup/setup.sh
```

## Apps installed

| Type | Apps |
|------|------|
| Brew formulae | azure-cli, exiftool, ffmpeg, git, jq, python, rclone, rsync, tmux, and more |
| Casks | Antigravity, ChatGPT, Chrome, Drive, Raspberry Pi Imager, VLC, VS Code |
| Mac App Store | Lightroom, WhatsApp, Windows App |
