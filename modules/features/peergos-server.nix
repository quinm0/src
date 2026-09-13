{ self, inputs, ... }: {

  # This is your module that imports and configures home-manager
  flake.nixosModules.peergos-server = { pkgs, ... }: {
    systemd.services.daemon-peergos = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Peergos Server";
      serviceConfig = {
        Type = "simple";
        ExecStart = "peergos daemon -listen-host tailscale0 -public-domain peergos.soupclown.com";
      };
    };
  };

}