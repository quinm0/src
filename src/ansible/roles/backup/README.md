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

  # Backup Schedule
    "backup_schedule": string | default="off"
  The cron schedule for the backup. Default is off. Ansible will do it's best to sync the state of the cron job with this value on the host. For example, enabling automatic backups at 2:00 AM daily "0 0 2 * * *"
