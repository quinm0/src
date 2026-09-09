{ config, lib, pkgs, modulesPath, self, inputs, ... }:

{
  # This is your system configuration entry-point
  flake.nixosConfigurations.d-lap = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.d-lap
      self.nixosModules.soupclown-common
      self.nixosModules.gui1
      self.nixosModules.soupclown-users
      self.nixosModules.homeManager
      self.nixosModules.steam
    ];
  };

  flake.nixosModules.d-lap = { config, lib, pkgs, modulesPath, ... } :{

    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    networking.hostName = "d-lap";
    system.stateVersion = "26.11";
    networking.networkmanager.enable = true;

    # Use the systemd-boot EFI boot loader.
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader = {
      efi.efiSysMountPoint = "/boot";
      systemd-boot.enable = true;
    };

    hardware.apple-t2.firmware.enable = true;
    
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = { 
      device = "/dev/disk/by-uuid/5ac9aa6d-ad72-474f-802b-fb49104eff55";
      fsType = "ext4";
    };

    swapDevices = [ 
      { device = "/dev/disk/by-uuid/93f4b86c-ce08-48ba-81ce-f7606e8d77dc"; }
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

}