# Here's backup role docs

Would like this to tar up all the paths in {backup_paths} and then tar up that file with .env var "BACKUP_ENCRYPTION_KEY" in file at {backup_env_path}. Logs should be with backups and in /var/log/backup.
Adds group backup

vars:
  
  # Backup Paths
    "backup_paths": string | array
  A list of paths to be backed up. No default paths. Default is empty array.

  # Backup Dir
    "backup_dir": string
  The path where the final backup tar is stored. Default is "/var/backup/" 
  
  # Backup Env Path
    "backup_env_path": string
  The path to the .env file specifically for storing the backup encryption key variable. Default is "/etc/backup/.env"

  # Backup retention days
    "backup_retention_days": number
  The number of days to keep the archives inside of the main tar file.

  # Backup Schedule enabled
    "backup_schedule_enabled": boolean
  If true then this will enable automatic backups with the cronjob

  # Backup Schedule
    "backup_schedule": "string"
  The cron schedule for the backup. Default is off. Ansible will do it's best to sync the state of the cron job with this value on the host. For example, enabling automatic backups at 2:00 AM daily "0 0 2 * * *"


## Operations

backupSTEP1:
creates a temp directory
If the backup directory is not empty then this means a new backup has been started while another backup was mid-restore or backup. The function generates a timestamp amd moved the partial backup to the backup destination with the timestamp and logs an INFO. Otherwise, all is good and function logs INFO

backupSTEP2:
temp dir is re-created just in case.
generates a zip dir
for each path in {{backup_paths}} get a name, timestamp and runs `tar -czf` on all of the paths and logs results. Individual tar files are not currently encrypted for simplicity. If any paths in {{backup_paths}} do not exist then it is logged as a WARNING.

backupSTEP3:
Creates readme file with creation date and paths list with hash. Calls `tar -czf - -C "zipdir" . -C "tempdir" . and then `| openssl enc -aes-256-cbc -salt -out "final_archive" -pass to encrypt the final backup.

backupSTEP4:
Deletes the temporary directory and logs result.