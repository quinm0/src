{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  fileSystems."/boot/firmware" =
    { device = "systemd-1";
      fsType = "autofs";
    };

  networking.hostName = "rpi4-pt1";
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";


  # We run sshd by default. Login is only possible after adding a
  # password via "passwd" or by adding a ssh key to ~/.ssh/authorized_keys.
  # The latter one is particular useful if keys are manually added to
  # installation device for head-less systems i.e. arm boards by manually
  # mounting the storage in a different system.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # We are stateless, so just default to latest.
  system.stateVersion = "26.11";

  # This is mostly portions of safe network configuration defaults that
  # nixos-images and srvos provide

  networking.useNetworkd = true;
  # mdns
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = "yes";
  };

  # This comment was lifted from `srvos`
  # Do not take down the network for too long when upgrading,
  # This also prevents failures of services that are restarted instead of stopped.
  # It will use `systemctl restart` rather than stopping it with `systemctl stop`
  # followed by a delayed `systemctl start`.
  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    # Services that are only restarted might be not able to resolve when resolved is stopped before
    systemd-resolved.stopIfChanged = false;
  };

  # Use iwd instead of wpa_supplicant. It has a user friendly CLI
  # networking.wireless.enable = false;
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      Settings.AutoConnect = true;
    };
  };


  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  environment.systemPackages = with pkgs; [
    tree
    gh
    btop
    ctop
    signal-desktop
    lazygit
    element-desktop
    vivaldi
    libreoffice-qt-fresh
    trash-cli
    # lutris
    gparted
    kitty
    neovim
    gimp
    kicad-small
    vscodium-fhs
    # ansible
    usbutils
    python313Packages.nomadnet
    screen
    jellyfin-desktop
    renpy
    # wine
    vlc
    restic
    prismlauncher
    jdk25_headless
    jekyll
    fastfetch
    python3
    esptool
    termsonic
  ];

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}