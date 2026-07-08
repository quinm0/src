{ config, pkgs, ... }:

{
  home-manager.users.dbowen = {
    home.stateVersion = "26.05";
    home.username = "dbowen";
    home.homeDirectory = "/home/dbowen";
    
    programs.git.enable = true;
    programs.bash = {
      enable = true;
      shellAliases = {
        btw = "echo i use nixos, btw";
      };
    };
  }; 

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
      tree
      chromium
      vscodium-fhs
      libreoffice-qt-fresh
      trash-cli
      gimp
      lutris
      wine
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
