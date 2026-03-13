{ config, pkgs, ... }:

{

  users.users.qmoran = {
    isNormalUser = true;
    description = "quin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      gh
      btop
      kdePackages.kate
      signal-desktop
      lazygit
      element-desktop
      vscodium
      vivaldi
    ];
  };

}
