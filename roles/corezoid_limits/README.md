# Corezoid Limits Role

This Ansible role installs and configures the `corezoid_limits` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the corezoid_limits package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Sets up the service to start automatically
- Configures Monit for service monitoring

## Requirements

- RHEL/CentOS 7/8/9 or Amazon Linux 2/2023
- Access to the AWS Corezoid repository
- Monit should be installed on the target system

## Role Variables

### Required Variables for box.yml

```yaml
top_dir: "/ebsmnt"
app_user: "app-user"

corezoid_release: 6.7.3

corezoid_release_app_version:
  corezoid_limits: "2.7.1"

corezoid_limits:
  version: "{{ corezoid_release_app_version.corezoid_limits }}"
  config: "{{ conf_dir }}/corezoid_limits.config"
corezoid_limits_config: "{{ conf_dir }}/corezoid_limits.config"
```

## Directory Structure

```
corezoid_limits/
├── defaults/          # Default variables
├── handlers/          # Handler definitions
├── meta/              # Role metadata
├── README.md          # This documentation file
├── tasks/             # Task definitions
│   └── main.yml       # Main tasks file
├── templates/         # Configuration templates
│   ├── *-corezoid_limits.config.j2
│   └── corezoid_limits.monit.j2
├── tests/             # Test files
└── vars/              # Role variables
```

## Role Variables

The role uses several variables that should be defined:

- `app_user`: The user that will own and run the service
- `top_dir`: Top-level directory for Erlang applications
- `corezoid_limits_config`: Path to the configuration file
- `corezoid_release`: Version of Corezoid release (e.g., "6.7.3")
- `corezoid_release_app_version.corezoid_limits`: Specific version of corezoid_limits to install

## Tags

The role uses the following tags for task control:

- `corezoid_limits-all`: All tasks for this role
- `corezoid_limits-app`: Application-related tasks
- `corezoid_limits-install`: Installation tasks
- `corezoid_limits-config-file`: Configuration file generation
- `corezoid_limits-start`: Service start tasks
- `corezoid_limits-monit`: Monitoring configuration tasks

## Usage Example

Include this role in your playbook:

```yaml
 - hosts: cz_api
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - role: corezoid_limits
```

To run only specific tasks, use tags:

```bash
ansible-playbook playbook.yml --tags "corezoid_limits-config-file"
```

## Author

Created and maintained by Middleware