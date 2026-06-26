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
            (import-tree ./nix/shared)
            stylix.nixosModules.stylix
            nixos-hardware.nixosModules.framework-11th-gen-intel
            ./nix/hw/qlhc.nix
            ./nix/services/enabled/syncthing.nix # Enable single shared service manually
            ./nix/services/deployer.nix # Testing this
          ];
        };
        nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import-tree ./nix/shared)
            (import-tree ./nix/services/enabled) # Server services
            stylix.nixosModules.stylix
            ./nix/hw/qdhc.nix
          ];
        };
      };
      systems = [
        "x86_64-linux"
      ];
    };
}


    
