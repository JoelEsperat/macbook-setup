#!/bin/zsh

# This media uses a non encrypted file system
# It is used for offline backup of critical non-sensitive data

BACKUP_METHOD="/opt/homebrew/bin/rsync"
BACKUP_ARGS="-avh --delete --progress"

SOURCE="joel@nas:/data/lightroom"
TARGET="/Volumes/Sandisk USB/Lightroom"
echo "Backing up from $SOURCE to $TARGET"
$BACKUP_METHOD $BACKUP_ARGS "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Photos"
TARGET="/Volumes/Sandisk USB/Photos"
echo "Backing up from $SOURCE to $TARGET"
$BACKUP_METHOD $BACKUP_ARGS "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Videos"
TARGET="/Volumes/Sandisk USB/Videos"
echo "\nBacking up from $SOURCE to $TARGET"
$BACKUP_METHOD $BACKUP_ARGS "$SOURCE/" "$TARGET/"

SOURCE="joel@nas:/data/google-drive/Photoshoots"
TARGET="/Volumes/Sandisk USB/Photoshoots"
echo "\nBacking up from $SOURCE to $TARGET"
$BACKUP_METHOD $BACKUP_ARGS "$SOURCE/" "$TARGET/"