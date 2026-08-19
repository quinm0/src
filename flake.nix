{
  description = "Quins NixOS flake!";

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];
    extra-trusted-public-keys = [ "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    stylix.url = "github:nix-community/stylix/release-26.05";

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
      };
      systems = [
        "x86_64-linux"
      ];
    };
}


    
