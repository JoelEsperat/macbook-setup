#!/bin/zsh

# This media uses an Apple encrypted file system
# It is used for a full offline backup

BACKUP_METHOD="/opt/homebrew/bin/rsync"
BACKUP_ARGS="-avh --delete --progress"
#BACKUP_ARGS="$BACKUP_ARGS --exclude=.DS_Store --exclude=._* --exclude=.Trashes --exclude=.Spotlight-V100 --iconv=utf-8,utf-8-mac"
SOURCE="joel@nas:/data/"
TARGET="/Volumes/Samsung USB/nas/"
echo "\nBacking up from $SOURCE to $TARGET"
$BACKUP_METHOD $BACKUP_ARGS "$SOURCE" "$TARGET"
