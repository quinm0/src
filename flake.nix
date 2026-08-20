{
  description = "Quins NixOS flake!";

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [ 
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=" 
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    stylix.url = "github:nix-community/stylix/release-26.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ 
    nixos-hardware, 
    nixpkgs,
    import-tree, 
    flake-parts, 
    home-manager, 
    stylix,
    nixos-raspberrypi,
   ... 
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations.qmoran-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/shared)
            nixos-hardware.nixosModules.framework-11th-gen-intel
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./nix/hw/qlhc.nix
          ];
        };

        nixosConfigurations.d-lap = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/shared)
            nixos-hardware.nixosModules.apple-t2
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./nix/hw/dlhc.nix
            ./nix/hw/substituter.nix # Need this for some t2 support(?)
          ];

        };

        nixosConfigurations.rpi4 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ({ config, pkgs, lib, nixos-raspberrypi, disko, ... }: {
              imports = with nixos-raspberrypi.nixosModules; [
                # Hardware configuration
                ./nix/shared/common.nix
                ./nix/shared/user-quin.nix
                home-manager.nixosModules.home-manager
                raspberry-pi-4.base
                raspberry-pi-4.display-vc4
                raspberry-pi-4.bluetooth
              ];
            })
            ./nix/hw/pi4hc.nix
            {
              boot.tmp.useTmpfs = true;
            }

            # Advanced: Use non-default kernel from kernel-firmware bundle
            ({ config, pkgs, lib, ... }: let
              kernelBundle = pkgs.linuxAndFirmware.v6_6_31;
            in {
              boot = {
                loader.raspberry-pi.firmwarePackage = kernelBundle.raspberrypifw;
                kernelPackages = kernelBundle.linuxPackages_rpi4;
              };

              nixpkgs.overlays = lib.mkAfter [
                (self: super: {
                  # This is used in (modulesPath + "/hardware/all-firmware.nix") when at least 
                  # enableRedistributableFirmware is enabled
                  # I know no easier way to override this package
                  inherit (kernelBundle) raspberrypiWirelessFirmware;
                  # Some derivations want to use it as an input,
                  # e.g. raspberrypi-dtbs, omxplayer, sd-image-* modules
                  inherit (kernelBundle) raspberrypifw;
                })
              ];
            })

          ];
        };
      };
      systems = [
        "x86_64-linux"
      ];
    };
}


    
