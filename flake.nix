{
  description = "Quins NixOS flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations.qmoran-laptop = nixpkgs.lib.nixosSystem {
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

    nixosConfigurations.qmoran-desktop = nixpkgs.lib.nixosSystem {
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
}

