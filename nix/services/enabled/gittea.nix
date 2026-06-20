{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;
  };
}