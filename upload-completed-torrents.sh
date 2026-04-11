#!/usr/bin/env bash

sudo rclone move --config /etc/rclone.conf --transfers 30 -P /mnt/tmpMedia/radarr data:enc/mnt/mega/app_data/complete_torrent_downloads
sudo rclone move --config /etc/rclone.conf --transfers 30 -P /mnt/tmpMedia/sonarr data:enc/mnt/mega/app_data/complete_torrent_downloads 