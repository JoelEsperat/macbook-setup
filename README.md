# macbook-setup

Personal MacBook configuration as code. Installs/updates apps, configures ZSH, SSH, and syncs credentials from a NAS.

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

Credentials (SSH private key, etc.) are pulled from a NAS over rsync and stored in `~/.credentials/`.

## Usage

```sh
git clone https://github.com/JoelEsperat/macbook-setup.git ~/Projects/macbook-setup
~/Projects/macbook-setup/setup.sh
```

> Requires network access to the NAS for the credentials sync step.

## Apps installed

| Type | Apps |
|------|------|
| Brew formulae | azure-cli, exiftool, ffmpeg, git, jq, python, rclone, rsync, tmux, and more |
| Casks | Antigravity, ChatGPT, Claude, Chrome, Drive, HandBrake, Raspberry Pi Imager, VLC, VS Code |
| Mac App Store | Lightroom, WhatsApp, Windows App |
