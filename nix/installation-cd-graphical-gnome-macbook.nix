{ config, ... }:

{
  imports = [ ./installation-cd-graphical-gnome.nix ];

  boot.initrd.kernelModules = [ "wl" ];

  boot.kernelModules = [
    "kvm-intel"
    "wl"
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
}