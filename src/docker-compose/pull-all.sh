#!/bin/bash

SERVICE_NAMES=("paperless" "jellyfin" "immich" "navidrome" "downloadin")
for SERVICE in "${SERVICE_NAMES[@]}"; do
    bash $(pwd)/${SERVICE}-pull.sh
done