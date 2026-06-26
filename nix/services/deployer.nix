{ config, lib, pkgs, modulesPath, ... }:

{

  
  systemd.tmpfiles.rules = [
    "d /etc/soupclown 0770 soupclown soupclownservice"
    "Z /etc/soupclown 0770 soupclown soupclownservice"
    "d /etc/soupclown/code 0770 soupclown soupclownservice"
    "Z /etc/soupclown/code 0770 soupclown soupclownservice"
  ];
      
  # Timer to trigger deployment service
  # systemd.timers."soupclown-deploy" = {
  #   wantedBy = [ "timers.target" ];
  #     timerConfig = {
  #       Unit = "soupclown-deploy.service";
        
  #       # OnBootSec = "5m";
  #       OnUnitActiveSec = "30s";
  #       Persistent = true; 
  #     };
  # };

  systemd.services."soupclown-deploy" = {
    script = ''
      set -eu
      ${pkgs.coreutils}/bin/echo "Hello World"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}