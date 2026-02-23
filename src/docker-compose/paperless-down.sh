#!/bin/bash
docker compose --env-file $(pwd)/paperless-compose.env -f $(pwd)/paperless-compose.yaml down