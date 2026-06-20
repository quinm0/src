{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;
    group = "soupclownservice";
    lfs.enable = true;
    database.type = "postgres";
    stateDir = "/etc/soupclown/gitea";
    lfs.contentDir = "/storage/gitea/lfs";
    repositoryRoot = "/storage/gitea/repo";
    settings = {
      service.DISABLE_REGISTRATION = true;
      log.LEVEL = "Trace";
      server = {
        # DOMAIN = "";
        SSH_PORT = 8269;
        HTTP_PORT = 4628;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /etc/soupclown/gitea 0770 gittea gittea"
    "Z /etc/soupclown/gitea 0770 gittea gittea"
    "d /storage/gitea/lfs 0770 gittea gittea"
    "Z /storage/gitea/lfs 0770 gittea gittea"
    "d /storage/gitea/repo 0770 gittea gittea"
    "Z /storage/gitea/repo 0770 gittea gittea"
  ];
}