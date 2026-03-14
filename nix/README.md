# It's NixOS!

Hello MtV and welcome to my crib. These are all the things pertaining to my nixos stuff.

- [./common.nix](./common.nix) is all the common things that hosts will have configured
  - Services
  - locale settings
  - timezone
- [./gui1](./gui1.nix) all config things for a linux UX experience, KDE Plasma in this instance, but perhaps there could be a gui2 someday...
- [./qlhc.nix](./qlhc.nix) this stands for quins-laptop-hardware-configuraion. I'll find a better way to do this stuff later.
- [./user-quin](./user-quin.nix) my personal user account, here for all to see.
  - packages
  - groups