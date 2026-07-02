#!/usr/bin/env bash

# Make and store tempdir
DIR=$(mktemp -d)
OGDIR=$(pwd)

pushd $DIR
echo "DIR is ($DIR)"

# Download nix source (could save this longterm or reference with nix)
git clone https://github.com/NixOS/nixpkgs.git
cd nixpkgs/nixos

# Copy iso config
# Change this if you dare
cp $OGDIR/nix/installation-cd-graphical-gnome-macbook.nix modules/installer/cd-dvd/installation-cd-graphical-gnome-macbook.nix 

export NIXPKGS_ALLOW_UNFREE=1
nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-graphical-gnome-macbook.nix default.nix


echo "DONE. (popd when done)"

