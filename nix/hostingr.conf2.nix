# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  # networking.networkmanager.enable = true; # According to hostingr "Dev" this is not supported so 
  networking.useDHCP = true;


  boot.cleanTmpDir = true;
  nix.settings.auto-optimise-store = true;

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  # time.timeZone = "Europe/Amsterdam";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  networking.firewall.enable = false;

  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  system.stateVersion = "26.05"; # Did you read the comment?

}
