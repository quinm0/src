#!/usr/bin/env bash

SESSION_NAMES=("radarr" "sonarr")
LOGFILE="${HOME}/screen_sessions.log"

# Map window names to commands (commands run as shells; use full paths or quotes if needed)
declare -A CMD_FOR_SESSION=(
  [radarr]='sudo rclone move --config /etc/rclone.conf --transfers 30 -P /mnt/tmpMedia/radarr data:enc/mnt/mega/app_data/complete_torrent_downloads'
  [sonarr]='sudo rclone move --config /etc/rclone.conf --transfers 30 -P /mnt/tmpMedia/sonarr data:enc/mnt/mega/app_data/complete_torrent_downloads'
)

timestamp(){ date --iso-8601=seconds; }

session_exists(){
  local name="$1"
  # screen -ls output contains lines like "1234.name"
  screen -ls 2>/dev/null | awk '{print $1}' | grep -Eq "\.${name}(\s|$)"
}

ensure_session(){
  local name="$1"
  local cmd="$2"

  if session_exists "$name"; then
    echo "$(timestamp) - Session '$name' already exists." >>"$LOGFILE"
    return 0
  fi

  # Start detached session named $name and run the command in its primary window
  # Use -S name -d -m to start detached, then run a shell to evaluate the command
  screen -S "$name" -d -m bash -lc "$cmd"
  if [ $? -eq 0 ]; then
    echo "$(timestamp) - Created session '$name' with command: $cmd" >>"$LOGFILE"
  else
    echo "$(timestamp) - FAILED to create session '$name' (command: $cmd)" >>"$LOGFILE"
    return 1
  fi
}

for name in "${SESSION_NAMES[@]}"; do
  cmd="${CMD_FOR_SESSION[$name]:-bash}"  # default to interactive bash if no command provided
  ensure_session "$name" "$cmd"
done