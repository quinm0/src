#!/usr/bin/env bash

sudo rclone move --config /etc/rclone.conf --dry-run --transfers 30 -P /mnt/tmpMedia/radarr data:enc/mnt/mega/app_data/complete_torrent_downloads 