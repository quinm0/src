{ pkgs, lib, ... }:
let
  mountPoint = "/mnt/mega";
  remoteName = "data";
  bucketName = "enc";
  configFile = "/etc/rclone.conf";
in
{
  environment.systemPackages = with pkgs;[
    rclone
  ];
  systemd.mounts = lib.singleton {
    where = mountPoint;
    what = "${remoteName}:${bucketName}";
    type = "rclone";
    # I think we need to be able to set a timeout here but nix is too new
    options = "_netdev,allow-other,vfs-cache-mode=full,vfs-read-chunk-size=512M,vfs-read-chunk-size-limit=1G,vfs-write-back=48h,vfs-cache-max-age=3h,config=${configFile},vvv,daemon-wait=0";
  };

  #systemd.automounts = lib.singleton {
  #  where = mountPoint;
  #  wantedBy = [ "multi-user.target" ];
  #};
}