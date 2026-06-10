{ config, lib, pkgs, modulesPath, ... }:

{

  systemd.tmpfiles.rules = [
    "d /etc/SoupCloud 0770 syncthing users"
    "Z /etc/SoupCloud 0770 syncthing users"
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = false; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    guiAddress = "0.0.0.0:8384"; # By default syncthing only listens to localhost
    guiPasswordFile = "/etc/syncthing-gui-password";
    settings = {
      gui.user = "qmoran";
      devices = {
        "desktop" = { id = "VV6CPFJ-CSKP3P5-N64WJ35-R66U24N-D6F4TGY-2VIOMLA-WIIORQQ-DULHNQT"; };
        # "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      };
      folders = {
        "SoupCloud" = {
          path = "/etc/SoupCloud";
          devices = [ "desktop" ];
        };
        "Restic" = {
          path = "/storage/restic";
          devices = [ "desktop" ];
        };
        # "Example" = {
        #   path = "/home/myusername/Example";
        #   devices = [ "device1" ];
        #   ignorePerms = false; # Enable file permission syncing
        # };
      };
    };
  };

}