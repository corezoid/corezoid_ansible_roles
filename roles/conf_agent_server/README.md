# Configuration Agent Server Role

This Ansible role installs and configures the `conf_agent_server` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the conf_agent_server package from the AWS Corezoid repository
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

corezoid_release: 6.7.3

corezoid_release_app_version:
  conf_agent_server: "2.7.1"

conf_agent_server:
  version: "{{ corezoid_release_app_version.conf_agent_server }}"
  config: "{{ conf_dir }}/conf_agent_server.config"
conf_agent_server_config: "{{ conf_dir }}/conf_agent_server.config"
```

## Directory Structure

```
conf_agent_server/
├── defaults/          # Default variables
├── handlers/          # Handler definitions
├── meta/              # Role metadata
├── README.md          # This documentation file
├── tasks/             # Task definitions
│   └── main.yml       # Main tasks file
├── templates/         # Configuration templates
│   ├── *-conf_agent_server.config.j2
│   └── conf_agent_server.monit.j2
├── tests/             # Test files
└── vars/              # Role variables
```

## Role Variables

The role uses several variables that should be defined:

- `app_user`: The user that will own and run the service
- `top_dir`: Top-level directory for Erlang applications
- `conf_dir`: Directory for configuration files
- `conf_agent_server_config`: Path to the configuration file
- `corezoid_release`: Version of Corezoid release (e.g., "6.7.3")
- `corezoid_release_app_version.conf_agent_server`: Specific version of conf_agent_server to install

## Tags

The role uses the following tags for task control:

- `conf_agent_server-all`: All tasks for this role
- `conf_agent_server-app`: Application-related tasks
- `conf_agent_server-install`: Installation tasks
- `conf_agent_server-config`: Configuration tasks
- `conf_agent_server-config-file`: Configuration file generation
- `conf_agent_server-start`: Service start tasks
- `conf_agent_server-monit`: Monitoring configuration tasks

## Usage Example

Include this role in your playbook:

```yaml
 - hosts: cz_api
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - role: conf_agent_server
```

To run only specific tasks, use tags:

```bash
ansible-playbook playbook.yml --tags "conf_agent_server-config"
```

## Author

Created and maintained by Middleware