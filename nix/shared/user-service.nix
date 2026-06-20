{ config, pkgs, ... }:

{
  users.users.soupclown = {
    uid = 700;
    group = "soupclownservice";
    isNormalUser = false;
    isSystemUser = true;
    description = "Soupclown service account";
    extraGroups = [
      "docker"
    ];
  };

  users.users.www-data = {
    isNormalUser = false;
    isSystemUser = true;
    group = "soupclownservice";
    description = "www-data acct";
  };

  users.groups = {
    soupclownservice = {
      gid = 700;
      members = [ 
        "qmoran" 
        "soupclown" 
        "syncthing" 
        "gitea"
      ];
    };
    www-data = {
      members = [ "www-data" ];
    };
  };
}
