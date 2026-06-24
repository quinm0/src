{ config, pkgs, lib, ... }:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        enable_gzip = true;
        domain = "grafana.soupclown.com";
        enforce_domain = false;
        http_port = 3437; 
      };

      analytics.reporting_enabled = false;
    };

    declarativePlugins = with pkgs.grafanaPlugins; [ ... ];
    provision = {
      enable = true;
      datasources.settings.datasources = [
        # Provisioning a built-in data source
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://qmoran-desktop-1:9090";
          isDefault = true;
          editable = false;
        }
      ];
    };
    
  };

}