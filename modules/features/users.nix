{ self, pkgs, inputs, ... }: {

  # Import users
  flake.nixosModules.soupclown-users = { pkgs, ... }: {
    imports = [
      self.nixosModules.user-quin
      self.nixosModules.user-dbowen
    ];
  };
}