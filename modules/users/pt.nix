{ self, pkgs, inputs, ... }: {

  flake.nixosModules.user-pt = { pkgs, ... }: {

    home-manager.users.pt = {
      home.stateVersion = "26.05";
      home.username = "pt";
      home.homeDirectory = "/home/pt";
      
      programs.git = {
        enable = true;
        settings = {
          user.name = "quinm0";
          user.email = "jolly2633@tutamail.com";
        };
      };

      programs.bash = {
        enable = true;
        shellAliases = {
          btw = "echo i use nixos, btw";
        };
      };
    }; 

    # My user for now
    users.users.pt = {
      isNormalUser = true;
      description = "prototype";
      extraGroups = [ 
        "wheel" 
        "docker" 
        "networkmanager"
        "dialout"
        "syncthing"
      ];
      packages = with pkgs; [
        gh
        btop
        ctop
        signal-desktop
        lazygit
        element-desktop
        libreoffice-qt-fresh
        trash-cli
        gparted
        kitty
        neovim
        usbutils
        python313Packages.nomadnet
        screen
        vlc
        restic
        jdk25_headless
        jekyll
        fastfetch
        python3
        esptool
        termsonic
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkhSg+CLjIYSZ+lTNkChYAP7uxpPrl1TvVPwCfYgSoa"
      ];
    };
  };
}