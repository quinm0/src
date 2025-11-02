# Ansible host setup

### About

This is made with the intent to be reuseable when any hosts on a network need to be configured back to a common state.

The default playbook only set's up the main raspberry pi I've been using but ideally some day it'll also set up the CM4 module to act as a router properly and ensure everything is up to date.

# Tasks

### Drive configs

Variables used:

- mount_point: an absolute path to mount all configured drives to
- drive_configs: An array of name, partuuid and fs_type

The drive config mounts all drives to the configured path. It also installs mergerfs and creates a common mount for all the drives in the mount point under `mount/`

### Python

Sets up python virtual environment
