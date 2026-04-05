{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nixos-hardware, lib, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {
      imports = [
      ];
      flake = {
        nixosConfigurations.qmoran-laptop = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/qlhc.nix
            ./nix/common.nix
            ./nix/user-quin.nix
            ./nix/gui1.nix
            ./nix/mega.nix
            nixos-hardware.nixosModules.framework-11th-gen-intel
          ];
        };
        nixosConfigurations.qmoran-desktop = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix/qdhc.nix
            ./nix/common.nix
            ./nix/user-quin.nix
            ./nix/gui1.nix
            ./nix/mega.nix
            ./nix/jf-server.nix
          ];
        };
      };
      systems = [
        "x86_64-linux"
      ];
      perSystem = { config, pkgs, ... }: {
      };
    });
}


    