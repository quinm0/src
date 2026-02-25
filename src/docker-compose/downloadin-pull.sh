#!/bin/bash
docker compose --env-file $(pwd)/downloadin.env -f downloadin-compose.yaml pull