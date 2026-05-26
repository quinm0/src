{ config, pkgs, ... }:

{
  # My user for now
  users.users.qmoran = {
    isNormalUser = true;
    description = "quin";
    extraGroups = [ 
      "wheel" 
      "docker" 
      "networkmanager"
      "dialout"
    ];
    packages = with pkgs; [
      gh
      btop
      ctop
      signal-desktop
      lazygit
      element-desktop
      vivaldi
      libreoffice-qt-fresh
      trash-cli
      lutris
      gparted
      kitty
      neovim
      gimp
      kicad-small
      rpi-imager
      vscodium-fhs
      ansible_2_18
      usbutils
      python313Packages.nomadnet
      screen
      jellyfin-desktop
      renpy
      wine
      beets
      vlc
      restic
      prismlauncher
      jdk25_headless
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
