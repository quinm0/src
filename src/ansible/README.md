# Ansible host setup

### About

This is made with the intent to be reuseable when any hosts on a network need to be configured back to a common state.
I've actually decided that this will only get the system configs and lower level configs in place for larger tools to then use the host for service orchistration.

# Tasks

- Install dependencies
- Create users
- Write env file
- Install Docker
- Install Rclone

## Variables:

```
- soupclown_users: list (Creates a user for each user and then also sets them as sudoer)
    - name: <username>
      isMod: true | false (sets as sudoer)
- soupclown_drive_configs: (not upgraded yet)
```
