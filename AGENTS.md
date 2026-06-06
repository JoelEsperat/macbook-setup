# Repository Guidelines

## Project Structure & Module Organization

This repository stores a personal macOS setup as code. The root scripts are the main entry points: `setup.sh` configures the machine end to end, `setup-apps.sh` installs Homebrew packages from `Brewfile`, and `setup-macos.sh` applies macOS defaults. Configuration files are grouped by target location: `zsh/` for shell startup snippets, `ssh/` for SSH config and known hosts, `git/` for global Git config, `etc/` for system files, and `sudoers.d/` for sudo policy. Utility scripts live in `bin/` and are copied to `~/.local/bin`.

## Build, Test, and Development Commands

- `./setup.sh`: full machine setup. This modifies system files, installs apps, copies dotfiles, and syncs credentials from the NAS.
- `./setup-apps.sh`: installs or updates Homebrew, runs `brew bundle install --file Brewfile`, and cleans up packages.
- `./setup-macos.sh`: applies macOS `defaults` settings. It is currently not called by default from `setup.sh`.
- `brew bundle check --file Brewfile`: verifies whether Brewfile dependencies are already installed.
- `zsh -n setup.sh setup-apps.sh setup-macos.sh bin/*.sh`: syntax-check shell scripts without executing them.

## Coding Style & Naming Conventions

Shell scripts use `zsh`, start with `#!/bin/zsh`, and should enable `set -euo pipefail`. Keep command output clear with short `echo` status messages. Prefer explicit paths and quoted variables, for example `"$(dirname "$0")/Brewfile"` and `"$HOME/.local/bin"`. Name utility scripts in `bin/` with lowercase, hyphen-separated action names ending in `.sh`, such as `compress-photos.sh`.

## Testing Guidelines

There is no formal test framework. Validate changes with `zsh -n` for modified scripts, then run the narrowest safe command. For package-only changes, prefer `brew bundle check --file Brewfile` before `./setup-apps.sh`. Avoid running `./setup.sh` casually because it changes `/etc/hosts`, sudoers, shell startup files, SSH files, and credentials.

## Commit & Pull Request Guidelines

Recent commits use short imperative or descriptive summaries, for example `Increase video quality` and `Add git configuration to setup`. Keep commit subjects focused on one change. Pull requests should describe what changed, list commands run, and call out system-impacting changes such as sudoers edits, host mappings, static routes, credential sync behavior, or app removals. Include screenshots only when changing user-visible app or macOS UI behavior.

## Security & Configuration Tips

Do not commit private keys or secrets. The public key in `ssh/id_ed25519.pub` is acceptable, but private credentials should stay in the NAS-backed `~/.credentials/` sync path. Treat `sudoers.d/`, `etc/hosts`, and SSH configuration changes as high impact and review them carefully before applying.
