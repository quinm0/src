{ self, pkgs, inputs, ... }: {

  # This is your home.nix, your module where you configure home-manager
  # It's imported both in standalone configuration above, and in your nixos configuration
  flake.nixosModules.soupclown-users = { pkgs, ... }: {
    qmoran = {
      isNormalUser = true;
      shell = pkgs.fish;
      description = "quin";
      extraGroups = [ 
        "wheel" 
        "docker" 
        "networkmanager"
        "dialout"
        "syncthing"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkhSg+CLjIYSZ+lTNkChYAP7uxpPrl1TvVPwCfYgSoa"
      ];
    };

  };
}