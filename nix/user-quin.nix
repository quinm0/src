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
    ];
    packages = with pkgs; [
      gh
      btop
      ctop
      kdePackages.kate
      signal-desktop
      lazygit
      element-desktop
      vscodium
      vivaldi
      libreoffice-qt-fresh
      ansible_2_18
      trash-cli
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}