#!/bin/bash

# Log function
# msg: Message to log
# lvl: Log level (INFO, WARN, ERROR)
# Description: Logs messages with [LVL] DDMMYY HHMMSS
log() {
    local msg="$1"
    local lvl="$2"
    local log_file="/var/log/backup/backup.log"
    local timestamp
    timestamp=$(date +"%d%m%y %H%M%S")
    local log_output="$timestamp : [${lvl}] $msg" # Added variable for logging output
    echo "$log_output" >> "$log_file"
}

# Function to load .env file from configured env path (from ansible template value bakup_env_path)
load_env() {
    local env_file="/mnt/mount/.env"
    if [ -f "$env_file" ]; then
        export $(grep -v '^#' "$env_file" | xargs)
        log "Environment variables loaded from $env_file" "INFO"
    else
        log "Environment file $env_file not found. Proceeding without loading env variables." "WARN"
    fi
  # If BACKUP_ENCRYPTION_KEY is not set, throw an error and exit
    if [ -z "$BACKUP_ENCRYPTION_KEY" ]; then
        log "BACKUP_ENCRYPTION_KEY is not set in the environment. Exiting." "ERROR"
        exit 1
    fi
}

# Read paths from file
read_paths() {
    local paths_file="/etc/backup/paths.txt"

    # Initialize an empty array to store valid paths
    paths_to_backup=()
    # Check if the file exists
    if [ ! -f "$paths_file" ]; then
        log "File $paths_file not found. Exiting." "ERROR"
        exit 1
    fi
    # Read lines from the file into the array, trimming whitespace and ignoring comments
    while IFS= read -r path; do
        # Skip empty lines and lines that start with a comment
        if [[ -n $path && ! "$path" =~ ^\s*# ]]; then
            paths_to_backup+=("$path")
        fi
    done < "$paths_file"
    # Check if any valid paths were found
    if [ ${#paths_to_backup[@]} -eq 0 ]; then
        log "No valid paths found in $paths_file. Exiting." "ERROR"
        exit 1
    fi
}

# Backup function pt-1 (Ensures temp dir was already done and closed)
# Should create a temp directory that's static. Should be checked to make sure it's empty before use.
# If not empty, log warning, and move contents to backup location with timestamp.
# Then if temp dir is empty proceed with success
backupSTEP1() {
    local temp_dir="/mnt/mount/backups/tmp/backup_temp"
    local backup_dest="/mnt/mount/backups"

    # Ensure temp directory exists
    mkdir -p "$temp_dir"
    # Check if temp directory is empty
    if [ "$(ls -A $temp_dir)" ]; then
        log "Temporary directory $temp_dir is not empty. Moving contents to backup destination." "WARN"
        local timestamp
        timestamp=$(date +"%Y%m%d_%H%M%S")
        mv "$temp_dir"/* "$backup_dest/partial-backup_$timestamp/"
        log "Moved contents of $temp_dir to $backup_dest/partial-backup_$timestamp/" "INFO"
    else
        log "Temporary directory $temp_dir is empty. Proceeding with backup." "INFO"
    fi
}

# Backup function pt-2
# Tar to archive all the paths specified into their own tar.gz file in temp_dir/zips
# Logging for each path zipped
# No encryption yet
backupSTEP2() {
    local temp_dir="/mnt/mount/backups/tmp/backup_temp"
    local zip_dir="$temp_dir/zips"  # Ensure zip_dir is correctly set
    # Create the temporary directory if it doesn't exist
    mkdir -p "$zip_dir"
    for path in "${paths_to_backup[@]}"; do
        if [ -e "$path" ]; then
            local base_name
            base_name=$(basename "$path")
            local timestamp
            timestamp=$(date +"%Y%m%d_%H%M%S")
            local archive_name="$zip_dir/${base_name}_$timestamp.tar.gz"
            tar -czfP "$archive_name" "$path"
            if [ $? -eq 0 ]; then
                log "Successfully backed up $path to $archive_name" "INFO"
            else
                log "Failed to back up $path" "ERROR"
            fi
        else
            log "Path $path does not exist. Skipping." "WARN"
        fi
    done
}

# Backup function pt-3
# Zip up all of the other zips into a single zip file with timestamp and encryption BACKUP_ENCRYPTION_KEY
# Add README file with list of paths backed up, timestamps, their expected sizes and hash sums
backupSTEP3() {
    local temp_dir="/mnt/mount/backups/tmp/backup_temp"
    local zip_dir="$temp_dir/zips"
    local backup_dest="/mnt/mount/backups"
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local selected_backup="$backup_dest/$timestamp.tar.gz"
    mkdir -p /mnt/mount/backups/partial-backup_$timestamp/ # ADDED: Create the destination directory
    tar -czvfP "$selected_backup" "$backup_dest"
    if [ $? -eq 0 ]; then
        log "Backup created successfully" "INFO"
    else
        log "Error creating backup" "ERROR"
        exit 1
    fi
    #Unzip and decrypt
    tar -xzvf "$selected_backup" -C "$temp_dir"
    #At this point the files are in temp_dir
    echo "Backup restored to /mnt/mount/backups/tmp/backup_temp. Please inspect the files before moving them."
}

# Main function, takes arguments to start or finish backups.
function main() {
    local action=$1
    read_paths
    load_env

    if [ "$action" == "backup" ]; then
        # Uncomment the following lines to enable backup steps
        # log "Starting backup process..." "INFO"
        backupSTEP1
        # backupSTEP2
        # backupSTEP3
    elif [ "$action" == "restore" ]; then
        log "Starting restore process..." "INFO"
        backupSTEP3
    else
        log "Invalid action. Please provide either 'backup' or 'restore'." "ERROR"
        exit 1
    fi
}

main "$@"