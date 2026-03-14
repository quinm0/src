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
    ];
  };
}