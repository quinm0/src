#!/usr/bin/env bash

sudo nixos-rebuild --flake .#$(hostname) switch
