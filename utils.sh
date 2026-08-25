#!/usr/bin/env bash

HOST=$(hostname)
HOST_PROFILE="host-$HOST"

GET_COMPOSE_PROFILES() {
  awk '
    /^[[:space:]]*profiles:[[:space:]]*$/ { p=1; next }
    p && /^[[:space:]]*-[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      print
      next
    }
    p { p=0 }
  ' ./docker-compose/compose.yaml | sort -u
}

mapfile -t ALL_COMPOSE_PROFILES < <(GET_COMPOSE_PROFILES)
ENABLED_COMPOSE_PROFILES=(
  $HOST_PROFILE
)

# Method to run docker compose commands
UPDATE_SERVICE_STATE(){

    # Default to up operation
    OPERATION="up -d"
    FINAL_COMPOSE_ARGS=""
    
    # Formulate profile args for up or down operation
    # If running down command then use all profiles to ensure services are off before backup
    # If runnin up only enable profiles listed ENABLED_COMPOSE_PROFILES
    # 
    for profile in "${ALL_COMPOSE_PROFILES[@]}"; do
        if [[ $1 == "down" ]]; then
            FINAL_COMPOSE_ARGS+=" --profile $profile"
        else
            # If current profile in ENABLED_COMPOSE_PROFILES then add to up compose args
            if [[ "${ENABLED_COMPOSE_PROFILES[*]}" =~ (^|[^[:alpha:]])$profile([^[:alpha:]]|$) ]]; then
                FINAL_COMPOSE_ARGS+=" --profile $profile"
            fi
        fi
    done    

    # Set operation to down if $1 == "down"
    # otherwise start services
    # 
    if [[ $1 == "down" ]]; then
        OPERATION="down"
        echo "[DOCKER COMPOSE] Stopping Services"
    else
        echo "[DOCKER COMPOSE] Starting Services"
    fi

    # ACTUAL DOCKER COMPOSE OPERATION COMMAND
    pushd ./docker-compose
    docker --log-level error compose $FINAL_COMPOSE_ARGS $OPERATION
    popd
}

UPDATE_SYSTEM_SERVICE_STATE(){
    if [[ $1 == "down" ]]; then
        sudo systemctl stop gitea syncthing
    else
        sudo systemctl start gitea syncthing
    fi
}

# MAIN TASKS
BACKUP(){
    UPDATE_SERVICE_STATE "down"
    UPDATE_SYSTEM_SERVICE_STATE "down"
    sudo restic -r /storage/restic --tag soupclownetc backup /etc/soupclown 
    UPDATE_SYSTEM_SERVICE_STATE "up"
    UPDATE_SERVICE_STATE "up"
}