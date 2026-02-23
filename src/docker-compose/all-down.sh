#!/bin/bash

SERVICE_NAMES=("paperless" "jellyfin" "immich" "navidrome" "deluge" "downloadin")
for SERVICE in "${SERVICE_NAMES[@]}"; do
    bash $(pwd)/${SERVICE}-down.sh
done
