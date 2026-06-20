{ config, lib, pkgs, modulesPath, ... }:

let
  mountName = "mega";
  mountPath = "/mnt/${mountName}";
  waitForFile = "/mnt/${mountName}/mega_connected";
  rcloneBucket = "data:enc";
  rcloneConfigPath = "/etc/rclone.conf";
in
{

  # Service that is good to wait on for the mount to be successful
  systemd.services."${mountName}-mount-wait" = {
    description = "Rclone mount wait service, good if you want other services to wait for it";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.bash ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'while [ ! -e ${waitForFile} ]; do sleep 1; done'";
      RemainAfterExit = true;
    };
  };

  # Actual mount service
  systemd.services."${mountName}-mount" = {
    description = "Rclone mount '${mountName}'";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.bash ];
  
    serviceConfig = {
      ExecStart = "${pkgs.rclone}/bin/rclone mount ${rcloneBucket} ${mountPath} -vv --vfs-cache-mode full --allow-other --fuse-flag allow_other --dir-perms 0777 --file-perms 0777 --umask 0 --dir-cache-time 300h --config ${rcloneConfigPath}";
      ExecStop = "umount /mnt/mega";
    };
  };

  # If docker is installed we'll make it wait to start
  systemd.services.docker.after = ["${mountName}-mount-wait.service"];
}