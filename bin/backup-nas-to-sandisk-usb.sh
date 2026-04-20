#!/bin/zsh
set -euo pipefail

# This media uses a non encrypted file system
# It is used for offline backup of critical non-sensitive data

BACKUP_METHOD="$(command -v rsync || true)"
if [ -z "$BACKUP_METHOD" ]; then
  BACKUP_METHOD="/opt/homebrew/bin/rsync"
fi
BACKUP_ARGS=(-avh --delete --progress)

SOURCE="joel@nas:/data/lightroom"
TARGET="/Volumes/Sandisk USB/Lightroom"
if [ ! -d "/Volumes/Sandisk USB" ]; then
  echo "Mount the Sandisk USB drive first."
  exit 1
fi
echo "Backing up from $SOURCE to $TARGET"
"$BACKUP_METHOD" "${BACKUP_ARGS[@]}" "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Photos"
TARGET="/Volumes/Sandisk USB/Photos"
echo "Backing up from $SOURCE to $TARGET"
"$BACKUP_METHOD" "${BACKUP_ARGS[@]}" "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Videos"
TARGET="/Volumes/Sandisk USB/Videos"
echo "Backing up from $SOURCE to $TARGET"
"$BACKUP_METHOD" "${BACKUP_ARGS[@]}" "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Photoshoots"
TARGET="/Volumes/Sandisk USB/Photoshoots"
echo "Backing up from $SOURCE to $TARGET"
"$BACKUP_METHOD" "${BACKUP_ARGS[@]}" "$SOURCE/" "$TARGET/"
