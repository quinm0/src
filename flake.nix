{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ 
    flake-parts, 
    nixos-hardware, 
    import-tree, 
    home-manager, 
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
            nixos-hardware.nixosModules.framework-11th-gen-intel
            ./nix/qlhc.nix
          ];
        };
        nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/modules)
            ./nix/qdhc.nix
            ./nix/jf-server.nix
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
          ];
        };
      };
      systems = [
        "x86_64-linux"
      ];
    };
}


    
