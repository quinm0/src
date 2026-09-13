{ self, inputs, ... }: {

  # This is your module that imports and configures home-manager
  flake.nixosModules.peergos-server = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      peergos
    ];

    systemd.services.daemon-peergos = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Peergos Server";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.peergos}/bin/peergos daemon -public-domain peergos.soupclown.com";
      };
    };
  };

}