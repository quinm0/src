{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;
    settings.service = {
      DISABLE_REGISTRATION = true;
    };
  };
}