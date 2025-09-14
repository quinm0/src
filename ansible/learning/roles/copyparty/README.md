# Copyparty Ansible Role

This role installs and configures Copyparty file server with flexible directory mapping and service management.

## Directory Variables
All main paths are configurable via variables. Override in inventory, playbook, or host_vars/group_vars as needed.

- `copyparty_data_dir`: Data directory (default: `/srv/copyparty`)
- `copyparty_working_dir`: Working directory (default: `/var/lib/copyparty`)
- `copyparty_log_dir`: Log directory (default: `/var/log/copyparty`)
- `copyparty_config_file`: Config file path (default: `/etc/copyparty.conf`)
- `copyparty_service_file`: Systemd service file (default: `/etc/systemd/system/copyparty.service`)

## Example Inventory Override
```
[webservers]
host1 copyparty_data_dir=/srv/copyparty1 copyparty_log_dir=/var/log/copyparty1
host2 copyparty_data_dir=/srv/copyparty2 copyparty_log_dir=/var/log/copyparty2
```

## Example Playbook Override
```
- hosts: all
  roles:
    - role: copyparty
      vars:
        copyparty_data_dir: /srv/copyparty_custom
        copyparty_log_dir: /var/log/copyparty_custom
```

## Tasks
- Ensures all required directories exist
- Installs Copyparty in a Python virtualenv
- Deploys config and systemd service from templates
- Enables and starts the service

## Templates
- `copyparty.conf.j2`: Uses variables for all paths
- `copyparty.service.j2`: Uses variables for working and log directories

## Extending
Add more variables for users, ports, or other Copyparty options as needed. See templates for usage.

## Idempotency
Role is idempotent and safe to re-run.

---
For questions or improvements, edit this README or contact the maintainer.
