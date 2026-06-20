{ config, pkgs, lib, ... }:

{
  enable = true;
  virtualHosts."example.org".extraConfig = ''
    respond "Hello, world!"
  '';
}