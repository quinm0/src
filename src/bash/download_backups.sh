#!/bin/bash

BACKUP_PATH="/mnt/mount/backup"
mkdir -p /home/qmoran/Downloads/po1Backups
scp qmoran@po1:$BACKUP_PATH/* /home/qmoran/Downloads/po1Backups