{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports = [(import "${home-manager}/nixos")];

  users.users.qmoran = {
    isNormalUser = true;
    description = "quin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      gh
      kdePackages.kate
      signal-desktop
      lazygit
    #  thunderbird
    ];
  };

  home-manager.users.qmoran = { pkgs, ... }: {
    home.packages = [ ];
    home.stateVersion = "25.11";
    programs.git = {
      enable = true;
      settings = {
        user.name = "quinm0";
        user.email = "jolly2633@tutamail.com";
        init.defaultBranch = "main";
      };
    };


  };
}
