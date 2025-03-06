# Usercode Role

This Ansible role installs and configures the `usercode` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the usercode package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Deploys required JavaScript libraries for functionality
- Installs SSL support libraries for Oracle Linux 8 environments
- Sets up secure permissions for application files
- Configures Monit for service monitoring
- Ensures services start automatically and survive reboots

## Requirements

- RHEL/CentOS 7/8/9, Oracle Linux, or Amazon Linux 2/2023
- Access to the AWS Corezoid repository
- Monit should be installed on the target system

## Role Variables

### Required Variables for box.yml

```yaml
top_dir: "/opt/corezoid"
conf_dir: "{{ top_dir }}/conf"
app_user: "app-user"

corezoid_release: 6.7.3

corezoid_release_app_version:
  usercode: "9.0.2"

usercode:
  version: "{{ corezoid_release_app_version.usercode }}"
  config: "{{ conf_dir }}/usercode.config"

```

## Templates and Files

The role requires the following templates and files:

### Templates
- `templates/[corezoid_release]-usercode.config.j2` - Main application configuration
- `templates/usercode.monit.j2` - Monit monitoring configuration

### Files
- `files/libcrypto.so.1.0.0` - SSL library for Oracle Linux 8
- `files/moment-timezone.js` - JavaScript library for timezone handling
- `files/sha256.js` - JavaScript library for SHA-256 hashing
- `files/sha512.js` - JavaScript library for SHA-512 hashing
- `files/hex.js` - JavaScript library for hex encoding/decoding

## Example Playbook

```yaml
- hosts: cz_usercode
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: usercode
```

## Role Structure

```
usercode/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── files/
│   ├── libcrypto.so.1.0.0  # SSL library for Oracle Linux 8
│   ├── moment-timezone.js  # JavaScript timezone library
│   ├── sha256.js           # JavaScript SHA-256 library
│   ├── sha512.js           # JavaScript SHA-512 library
│   └── hex.js              # JavaScript hex encoding library
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-usercode.config.j2    # Configuration templates
│   └── usercode.monit.j2       # Monit configuration template
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `usercode-all` - Run all tasks
- `usercode-install` - Just install the package
- `usercode-config` - Update configuration files
- `usercode-config-file` - Update only the main config file
- `usercode-add-libs` - Install JavaScript libraries
- `usercode-install-permission` - Fix file permissions
- `usercode-start` - Start the service
- `usercode-monit` - Update Monit configuration

Example:
```
ansible-playbook -i inventory playbook.yml --tags "usercode-config"
```

## Author

Created and maintained by Middleware