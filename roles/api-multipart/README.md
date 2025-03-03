# Conveyor API Multipart Role

This Ansible role installs and configures the `conveyor_api_multipart` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the conveyor_api_multipart package from a designated repository
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
conf_dir: "{{ top_dir }}/conf"
app_user: "app-user"

api_mult_nginx: true
api_mult_version: "{{ corezoid_release_app_version.mult }}"
api_mult_config: "{{ conf_dir }}/conveyor_api_multipart.config"
api_mult_port: 9082
api_mult_file_storage: "f3"
api_mult_file_f3_path_to_dir: "/ebsmnt_share"
api_mult_ttl_file: 60
api_mult_cluster_port: 5567
api_mult_login_id: 3
api_mult_login_secret: "z2JUCu7j8LS7lKR3V0mYrtVuFcdzo3XSZgLVqjctCzlmqOoSOA"
mult_hosts:
  - { host: "10.70.0.12" }
```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-conveyor_api_multipart.config.j2` - Main application configuration
- `templates/conveyor_api_multipart.monit.j2` - Monit monitoring configuration

## Example Playbook

```yaml
 - hosts: cz_mult
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - role: api-multipart
```

## Role Structure

```
redis/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-conveyor_api_multipart.config.j2    # Configuration templates
│   └── conveyor_api_multipart.monit.j2         # Monit configuration template
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `api-multipart-all` - Run all tasks
- `api-multipart-install` - Just install the package
- `api-multipart-env` - Set up directories
- `api-multipart-config` - Update configuration
- `api-multipart-monit` - Update Monit configuration

Example:
```
ansible-playbook -i inventory playbook.yml --tags "api-multipart-config"
```

## Author

Created and maintained by Middleware