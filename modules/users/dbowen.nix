{ self, pkgs, inputs, ... }: {

  flake.nixosModules.user-dbowen = { pkgs, ... }: {
    users.users.dbowen = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "dbowen";
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

    home-manager.users.dbowen = {
      home.stateVersion = "26.05";    
      home.username = "dbowen";
      home.homeDirectory = "/home/dbowen";

      programs.git.enable = true;
      programs.bash = {
        enable = true;
        shellAliases = {
          btw = "echo i use nixos, btw";
        };
      };
    };
  };
}