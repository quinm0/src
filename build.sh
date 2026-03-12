#!/usr/bin/env bash

sudo nixos-rebuild switch -I $(pwd)/configuration.nix
