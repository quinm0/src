# I modified it >:3
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =[ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "qmoran-laptop";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.initrd.luks.devices."luks-ca82dbc3-42a8-4582-99b6-0b6d271dc897".device = "/dev/disk/by-uuid/ca82dbc3-42a8-4582-99b6-0b6d271dc897";
  # Avoid touchpad click to tap (clickpad) bug. For more detail see:
  # https://wiki.archlinux.org/title/Touchpad_Synaptics#Touchpad_does_not_work_after_resuming_from_hibernate/suspend
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  
  # boot.initrd.kernelModules = [ ]; # Woah this might be helpful for those routers I have!
  # boot.extraModulePackages = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-df4da4a4-149f-433d-a0c9-efcb7f3acc52".device = "/dev/disk/by-uuid/df4da4a4-149f-433d-a0c9-efcb7f3acc52";

  swapDevices = [ 
    { 
      device = "/dev/mapper/luks-df4da4a4-149f-433d-a0c9-efcb7f3acc52"; 
    }
  ];

  fileSystems."/" = { 
    device = "/dev/mapper/luks-ca82dbc3-42a8-4582-99b6-0b6d271dc897";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/5C65-493B";
    fsType = "vfat";
    options = [ 
      "fmask=0077" 
      "dmask=0077"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

}
