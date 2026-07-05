{ config, pkgs, ... }:

{
  environment.etc."nextcloud-admin-pass".text = "sahldfkajfhldfhiu43h989phfre";
  
  services.nextcloud = {
    enable = true;
    hostName = "qmoran-desktop-1";
    package = pkgs.nextcloud33;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };

  # Startup config options
  systemd.services.nextcloud-custom-config = {
    path = [
      config.services.nextcloud.occ
    ];
    script = ''
      nextcloud-occ theming:config name "Soupcloud"
      nextcloud-occ theming:config url "https://cloud.soupclown.com";
      nextcloud-occ theming:config color "#3253a5";
    '';
    # nextcloud-occ theming:config privacyUrl "https://www.mine.com/privacy";
    # nextcloud-occ theming:config logo ${./logo.png}
    after = [ "nextcloud-setup.service" ];
    wantedBy = [ "multi-user.target" ];
  };

}
