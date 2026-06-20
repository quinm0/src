{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    stylix.url = "github:nix-community/stylix/release-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    ... 
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        home-manager.flakeModules.home-manager
      ];
      flake = {
        nixosConfigurations.qmoran-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/modules/shared)
            stylix.nixosModules.stylix
            nixos-hardware.nixosModules.framework-11th-gen-intel
            ./nix/hw/qlhc.nix
          ];
        };
        nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/modules/shared)
            (import-tree ./nix/modules/services/enabled) # Server services
            stylix.nixosModules.stylix
            ./nix/hw/qdhc.nix
          ];
        };
      };
      perSystem = { pkgs, ... }: {
        devShells.espdev = pkgs.mkShell {
          shellHook =
            ''
              echo "Codecell devshell"
            '';
          packages = with pkgs; [
            esptool
            clang-tools
          ];
        };
      };
      systems = [
        "x86_64-linux"
      ];
    };
}


    
