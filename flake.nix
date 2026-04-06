{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nixos-hardware, import-tree, nixpkgs, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {
      imports = [
      ];
      flake = {
        nixosConfigurations.qmoran-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./modules)
            nixos-hardware.nixosModules.framework-11th-gen-intel
            ./nix/qlhc.nix
          ];
        };
        nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./modules)
            ./nix/qdhc.nix
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


    