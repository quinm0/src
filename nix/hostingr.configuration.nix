# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Base system things that all should know and love
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;

  # Services
  virtualisation.docker.enable = true; # Docker
  services.tailscale.enable = true; # Tailscale

  # BIOS Boot supposedly /dev/sda has our boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # UEFI option which is not for VPS hostingr I think
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.efiSupport = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  users.users.qmoran = {
    isNormalUser = true;
    description = "quin";
    extraGroups = [ 
      "wheel" 
      "docker" 
      "networkmanager"
      "dialout"
      "syncthing"
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "qmoran" ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    tailscale
    rclone
    mergerfs
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}

# hardware-configuration.nix
# boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "virtio_blk" "virtio_net" ];

# fileSystems."/" =
#   { 
#     device = "/dev/disk/by-label/nixos";
#     fsType = "ext4";
#     options = [
#       "x-systemd.growfs"
#     ];
#   };

