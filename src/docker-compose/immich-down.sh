#!/bin/bash
docker compose --env-file $(pwd)/immich.env -f immich-compose.yaml down