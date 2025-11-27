#!/bin/bash

BACKUP_PATH="/mnt/mount/backup/"
PATHS_FILE="/etc/backup/paths.txt"


# Read all backups 
mapfile -t backup_archives < <(ls $BACKUP_PATH | grep '\.tar.gz$')

if [[ ${#backup_archives[@]} ]]; then
  echo "no backups :("
  exit 0
fi

for backup in "${backup_archives[@]}"; do
  echo "- $backup"
done