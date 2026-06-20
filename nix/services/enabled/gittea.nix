{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;
    lfs.enable = true;
    database.type = "postgres";
    stateDir = "/etc/soupclown/gittea";
    lfs.contentDir = "/storage/gitea/lfs";
    repositoryRoot = "/storage/gitea/repo";
    settings.service.DISABLE_REGISTRATION = false;
    
    settings.server = {
      # DOMAIN = "";
      SSH_PORT = 8269;
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/soupclown/gittea 0770 gittea gittea"
    "Z /etc/soupclown/gittea 0770 gittea gittea"
    "d /storage/gitea/lfs 0770 gittea gittea"
    "Z /storage/gitea/lfs 0770 gittea gittea"
    "d /storage/gitea/repo 0770 gittea gittea"
    "Z /storage/gitea/repo 0770 gittea gittea"
  ];
}