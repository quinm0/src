#!/bin/bash

SERVICE_NAMES=(
    "paperless"
    "jellyfin"
    "immich"
    "navidrome"
    # "downloadin"
    "matrix"
)
for SERVICE in "${SERVICE_NAMES[@]}"; do
    docker compose --env-file /etc/.soupclown.env -f $(pwd)/${SERVICE}-compose.yaml up
done
