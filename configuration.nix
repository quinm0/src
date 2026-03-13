{ config, pkgs, ... }:

{
  # Base system things that all should know and love
  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
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
  ];

  networking.networkmanager.enable = true;
  networking.hostName = "qmoran-laptop";

  imports = [
    ./hardware-configuration.nix
    ./users.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-df4da4a4-149f-433d-a0c9-efcb7f3acc52".device = "/dev/disk/by-uuid/df4da4a4-149f-433d-a0c9-efcb7f3acc52";

  # Services
  virtualisation.docker.enable = true; # Docker
  services.printing.enable = true; # CUPS
  services.tailscale.enable = true; # Tailscale

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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
