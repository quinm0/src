{ config, pkgs, system, inputs, ... }:

{
  # Base system things that all should know and love
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;

  #Services
  virtualisation.docker.enable = true; # Docker
  services.printing.enable = true; # CUPS
  services.tailscale.enable = true; # Tailscale
  services.flatpak.enable = true; # Flatpak

  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [ 
    "nix-command"
    "flakes" 
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.12-ecdsa-0.19.1" # I'm sure this is fine (just don't use python for anything important like usual)
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

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
    mergerfs
  ];

  systemd.settings.Manager = { 
    DefaultLimitNOFILE = "8192:524288";
  };

  # Automatic cleanups
  boot.tmp.cleanOnBoot = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
}