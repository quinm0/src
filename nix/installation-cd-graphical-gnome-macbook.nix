{ config, ... }:

{
  imports = [ 
    ./installation-cd-graphical-gnome.nix
    # ./installation-cd-minimal.nix
    ./channel.nix
  ];

  nixpkgs.config.allowUnfree = true;
  boot.kernelModules = [ "kvm-intel" "wl"];
  boot.initrd.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.blacklistedKernelModules = [ "b43" "bcma" ];
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # the default governor constantly runs all cores on max frequency
  # schedutil will run at a lower frequency and boost when needed
  powerManagement.cpuFreqGovernor = "schedutil";

  # install wpa_supplicant
  networking.wireless.enable = true;
}