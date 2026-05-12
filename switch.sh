#!/usr/bin/env bash
sudo nix-collect-garbage --delete-older-than 5d
sudo nixos-rebuild --flake . switch;
