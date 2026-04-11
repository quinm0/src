{ config, pkgs, ... }:

{
  # Base system things that all should know and love
  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;

  #Services
  virtualisation.docker.enable = true; # Docker
  services.printing.enable = true; # CUPS
  services.tailscale.enable = true; # Tailscale

  nix.settings.experimental-features = [ 
    "nix-command"
    "flakes" 
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git
    tailscale
    rclone
  ];
}