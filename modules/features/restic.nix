{ config, lib, pkgs, modulesPath, ... }:

{

  # systemd.tmpfiles.rules = [
  #   # Create 
  #   "d /etc/restic-backup 0770 root root" # Soupcloud dir
  #   "d /etc/secrets/secureRestic 0770 " # Encryption password file

  #   # Set perms
  #   "Z /etc/restic-backup 0770 root root"
  #   "Z /etc/secrets/secureRestic 0770 root root"
  # ];

  flake.nixosModules.restic = {}: {
    config.services.restic.backups = {
      soupclownBackups = {
        initialize = true;
        repository = "/etc/restic-soupclown";
        passwordFile = "/etc/secrets/restic";
        environmentFile = "/etc/.soupclown.env";
        exclude = [
          "*/.cache"
        ];
        paths = [
          "/etc/soupclown"
        ];
        checkOpts = [
          "--with-cache" # just to make checks faster
        ];
        extraBackupArgs = [
          "--tag soupclown"
        ];
        extraOptions = [
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 10"
        ];
        timerConfig = {
          OnBootSec = "3m";
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
  };

}