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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = pkgs.fetchurl {
      url = "https://getwallpapers.com/wallpaper/full/1/4/3/523784.jpg";
      hash = "sha256-S/6kgloXiIYI0NblT6YVXfqELApbdHGsuYe6S4JoQwQ=";
    };
    fonts = {
      serif = {
        package = pkgs.google-fonts;
        name = "Play-Regular";
      };
    };
  };
}