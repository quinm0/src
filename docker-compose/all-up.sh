#!/run/current-system/sw/bin/bash

SERVICE_NAMES=(
    # "paperless"
    "downloadin"
    # "matrix"
)
for SERVICE in "${SERVICE_NAMES[@]}"; do
    docker compose --env-file /etc/.soupclown.env -f $(pwd)/${SERVICE}-compose.yaml up -d
done
