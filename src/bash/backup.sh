#!/bin/bash

BACKUP_PATH="/mnt/mount/backup/"
PATHS_FILE="/etc/backup/paths.txt"

# Pull paths from /etc/backup/paths.txt into array
declare -a paths_to_backup
mapfile -t paths_to_backup < "$PATHS_FILE"

echo "Paths that are configured to backup"
for path in "${paths_to_backup[@]}"; do
  echo "- $path"
done

echo "Validating paths exist"
declare -a validated_paths
for path in "${paths_to_backup[@]}"; do
  if [ -d "$path" ]; then
    validated_paths+=($path)
  fi
done

echo "DEBUG: validated_paths"
for path in "${validated_paths[@]}"; do
  echo "- $path"
done

echo "Creating temp directory"

mkdir -p /mnt/mount/backup/tmp

echo "Taring directories"
for path in "${validated_paths[@]}"; do
  echo "Makng temporary copy of backup dir: ($path)"
  rclone copy -P $path /mnt/mount/backup/tmp/$(basename $path)
done

echo "Running final tar"
datestamp=$(date +"%H%M%S%d%m%y")

tar -czvf "/mnt/mount/backup/backup_$datestamp.tar.gz" "${validated_paths[@]}"

echo "Backup created successfully"

echo "Removing temporary files"
rm -rf /mnt/mount/backup/tmp

echo "Done!"