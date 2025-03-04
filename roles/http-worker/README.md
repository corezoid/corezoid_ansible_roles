# HTTP Worker Role

This Ansible role installs and configures the `http-worker` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the http-worker package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Configures Monit for service monitoring
- Sets up worker ID rotation for autoscale environments

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
  http_worker: "4.2.1.2"

http_worker:
  version: "{{ corezoid_release_app_version.http_worker }}"
  config: "{{ conf_dir }}/http_worker.config"

#http-worker settings
http_worker_max_http_resp_size: 5242880
http_worker_max_keep_alive_connections_len: 0
http_worker_pgsql_min_size: 0

rmq_logs: false
```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-http_worker.config.j2` - Main application configuration
- `templates/http-worker.monit.j2` - Monit monitoring configuration

## Example Playbook

```yaml
- hosts: cz_http
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: http-worker
```

## Role Structure

```
http-worker/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-http_worker.config.j2    # Configuration templates
│   └── http-worker.monit.j2       # Monit configuration template
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `http-worker-all` - Run all tasks
- `http-worker-install` - Just install the package
- `http-worker-config` - Update configuration files
- `http-worker-config-file` - Update only the main config file
- `http-worker-start` - Start the service
- `http-worker-monit` - Update Monit configuration


Example:
```
ansible-playbook -i inventory playbook.yml --tags "http-worker-config"
```

## Author

Created and maintained by Middleware