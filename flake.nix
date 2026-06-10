{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix/release-26.05";
  };

  outputs = inputs@{ 
    flake-parts, 
    nixos-hardware, 
    import-tree, 
    home-manager, 
    stylix,
    nixpkgs, 
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
            (import-tree ./nix/modules)
            stylix.nixosModules.stylix
            nixos-hardware.nixosModules.framework-11th-gen-intel
            ./nix/qlhc.nix
          ];
        };
        nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/modules)
            stylix.nixosModules.stylix
            ./nix/qdhc.nix
            ./nix/jf-server.nix
            ./nix/syncthing.nix
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


    
