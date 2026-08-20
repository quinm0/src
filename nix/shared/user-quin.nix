{ config, pkgs, ... }:

{

  home-manager.useUserPackages = true;
  home-manager.users.qmoran = {
    home.stateVersion = "26.05";
    home.username = "qmoran";
    home.homeDirectory = "/home/qmoran";
    home.packages = with pkgs; [
      gh
      btop
      ctop
      signal-desktop
      lazygit
      element-desktop
      vivaldi
      libreoffice-qt-fresh
      trash-cli
      # lutris
      gparted
      kitty
      neovim
      gimp
      kicad-small
      vscodium-fhs
      # ansible
      usbutils
      python313Packages.nomadnet
      screen
      jellyfin-desktop
      renpy
      # wine
      vlc
      restic
      prismlauncher
      jdk25_headless
      jekyll
      fastfetch
      python3
      esptool
      termsonic
    ];
    
    programs.git = {
      enable = true;
      settings = {
        user.name = "quinm0";
        user.email = "jolly2633@tutamail.com";
      };
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        btw = "echo i use nixos, btw";
      };
    };
  }; 

  # My user for now
  users.users.qmoran = {
    isNormalUser = true;
    description = "quin";
    extraGroups = [ 
      "wheel" 
      "docker" 
      "networkmanager"
      "dialout"
      "syncthing"
    ];
    
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkhSg+CLjIYSZ+lTNkChYAP7uxpPrl1TvVPwCfYgSoa"
    ];
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  # };
}
