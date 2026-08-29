{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.qmoran-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.qmoran-laptop-hw
      self.nixosModules.qmoran-laptop
      self.nixosModules.soupclownHomeManager
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.qmoran-laptop = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vim
      pkgs.firefox
    ];

    users.users.USERNAME = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    home-manager.users.USERNAME = self.homeModules.USERNAMEModule;
  };

}