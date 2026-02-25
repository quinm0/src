#!/bin/bash
docker compose --env-file $(pwd)/matrix.env -f matrix-compose.yaml pull