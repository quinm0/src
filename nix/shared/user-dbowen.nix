{ config, pkgs, ... }:

{
  # My user for now
  users.users.dbowen = {
    isNormalUser = true;
    description = "darby";
    extraGroups = [ 
      "wheel" 
      "networkmanager"
      "dialout"
      "syncthing"
    ];
    packages = with pkgs; [
      signal-desktop
      element-desktop
      vivaldi
      libreoffice-qt-fresh
      lutris
      gparted
      gimp
      usbutils
      jellyfin-desktop
      renpy
      wine
      vlc
      restic
      prismlauncher
      jdk25_headless
      jekyll
      python3
      strawberry
      termsonic
      ladybird
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
