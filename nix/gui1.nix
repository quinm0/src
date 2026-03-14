{ config, pkgs, ... }:

{
  # GUI / UX
  services.xserver.enable = true;
  services.xserver.excludePackages = [
    pkgs.xterm
  ];
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}