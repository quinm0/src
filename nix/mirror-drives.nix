{ config, pkgs, ... }:

{
  fileSystems."/soupstore" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/disks/soupstore/*";
    options = [
      "use_ino" 
      "cache.files=off"
      "dropcacheonclose=true" 
      "category.create=mfs"
      "minfreespace=10G"
    ];
  };
    
  
  fileSystems."/mnt/disks/soupstore/disk1" = { 
    device = "/dev/disk/by-uuid/fa20e116-e04e-4f3e-bf5a-c2e2c1fad610";
    fsType = "ext4";
    options = ["noatime" "nodiratime"];
  };

}