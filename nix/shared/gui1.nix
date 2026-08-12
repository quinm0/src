{ config, pkgs, ... }:

{
  # GUI / UX
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
  # programs.ssh = {
  #   startAgent = true;
  #   enableAskPassword = true;
  # };

  # environment.variables = {
  #   SSH_ASKPASS_REQUIRE = "prefer";
  # };


  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  #   image = pkgs.fetchurl {
  #     url = "https://getwallpapers.com/wallpaper/full/1/4/3/523784.jpg";
  #     hash = "sha256-S/6kgloXiIYI0NblT6YVXfqELApbdHGsuYe6S4JoQwQ=";
  #   };
  #   fonts = {
  #     serif = {
  #       package = pkgs.google-fonts;
  #       name = "Play-Regular";
  #     };
  #   };
  # };
}
