{ config, pkgs, ... }:

{

  users.users.soupclown = {
    uid = 700;
    group = "soupclownservice";
    isNormalUser = false;
    isSystemUser = true;
    description = "Soupclown service account";
  };

  users.groups = {
    soupclownservice = {
      gid = 700;
      members = [ "qmoran" "soupclown" ];
    };
  };
}
