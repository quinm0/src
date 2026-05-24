#!/usr/bin/env bash

echo "Stopping Services"
pushd ./docker-compose
docker compose --profile app down
docker compose --profile download down
docker compose --profile infra down
popd

sudo restic -r /storage/restic --tag soupclownetc backup /etc/soupclown 

echo "Restarting services"
pushd ./docker-compose
docker compose --profile app up -d
docker compose --profile download up -d
docker compose --profile infra up -d
popd