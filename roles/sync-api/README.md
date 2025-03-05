# Corezoid API Sync Role

This Ansible role installs and configures the `corezoid_api_sync` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the corezoid_api_sync package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Installs and configures Nginx as a reverse proxy
- Sets up SSL certificates for secure communication
- Configures Monit for service monitoring
- Ensures services start automatically and survive reboots

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
  sync_api: "3.7.1"

corezoid_api_sync:
  config: "{{ conf_dir }}/corezoid_api_sync.config"
  domain: "syncapi-ae-7682.middleware.biz"
  app_port: 8092
  api_user_id: 4
  api_user_secret: "xvq8rZXyL9JzwcIFiioDCx0lCpG75wa5Nld6EKMFAOhfjeVWJr"
  max_timeout: 180000

corezoid_api_sync_nginx:
  upstreams:
    - { host: "127.0.0.1" }

# Nginx configuration
nginx_ssl_dir: "/etc/nginx/ssl"
nginx_ssl_content: "{{ corezoid_demo_pem }}"
nginx_ssl_filename: "{{ nginx_ssl_dir }}/corezoid.pem"
nginx_limit_req: "thousand"

```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-corezoid_api_sync.config.j2` - Main application configuration
- `templates/corezoid_api_sync.monit.j2` - Monit monitoring configuration
- `templates/[corezoid_release]-01_syncapi.conf.j2` - Nginx main configuration
- `templates/upstream.conf.j2` - Nginx upstream configuration
- `templates/status.conf.j2` - Nginx status page configuration
- `templates/cert-corezoid.j2` - SSL certificate configuration
- `templates/nginx.conf.j2` - Nginx main configuration file

## Example Playbook

```yaml
- hosts: cz_api_sync
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: sync-api
```

## Role Structure

```
corezoid_api_sync/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-corezoid_api_sync.config.j2    # Configuration templates
│   ├── corezoid_api_sync.monit.j2       # Monit configuration template
│   ├── *-01_syncapi.conf.j2             # Nginx API configuration
│   ├── upstream.conf.j2                 # Nginx upstream configuration
│   ├── status.conf.j2                   # Nginx status configuration
│   ├── cert-corezoid.j2                 # SSL certificate configuration
│   └── nginx.conf.j2                    # Nginx main configuration
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `corezoid_api_sync-all` - Run all tasks
- `corezoid_api_sync-install` - Just install the package
- `corezoid_api_sync-config` - Update configuration files
- `corezoid_api_sync-config-file` - Update only the main config file
- `corezoid_api_sync-app` - Update only app
- `corezoid_api_sync-monit` - Update Monit configuration
- `corezoid_api_sync-nginx-setup` - Configure Nginx
- `corezoid_api_sync-nginx-configs` - Update Nginx configuration files
- `corezoid_api_sync-nginx-setup-ssl` - Configure SSL certificates

Example:
```
ansible-playbook -i inventory playbook.yml --tags "corezoid_api_sync-config"
```

## Author

Created and maintained by Middleware