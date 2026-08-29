{ self, pkgs, inputs, ... }: {

  # Import users
  flake.nixosModules.soupclown-users = { pkgs, ... }: {
    imports = [
      self.nixosModules.user-quin
      self.nixosModules.user-dbowen
    ];
  };

  flake.homeModules.soupclown-users-home = { pkgs, ... }: {
    imports = [
      self.homeModules.user-qmoran-home
      self.homeModules.user-dbowen-home
    ];
  };


}