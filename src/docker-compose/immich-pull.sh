#!/bin/bash
docker compose --env-file $(pwd)/immich.env -f $(pwd)/immich-compose.yaml pull