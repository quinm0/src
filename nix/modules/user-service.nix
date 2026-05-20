{ config, pkgs, ... }:

{
  users.groups = {
    soupclownservice = {
      gid = 700;
      members = [ "qmoran" ];
    };
  };
}
