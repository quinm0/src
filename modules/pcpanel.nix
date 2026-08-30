{ inputs, self, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.pcpanel =
      pkgs.callPackage ../packages/pcpanel.nix { };
  };

  flake.nixosModules.pcpanel = { pkgs, ... }:
    let
      pcpanel = self.packages.${pkgs.system}.pcpanel;
    in
    {
      environment.systemPackages = [
        pcpanel
      ];

      services.udev.packages = [
        pcpanel
      ];

      systemd.user.services.pcpanel = {
        description = "PCPanel";
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = "${pcpanel}/bin/pcpanel quiet";
          Restart = "on-failure";
        };

        wantedBy = [ "graphical-session.target" ];
      };
    };
}
