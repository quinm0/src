{ self, inputs, ... }: {
  flake.nixosModules.gui1 = { config, lib, pkgs, modulesPath, ... } :{
    services.xserver.excludePackages = [
      pkgs.xterm
    ];
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.dconf.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}