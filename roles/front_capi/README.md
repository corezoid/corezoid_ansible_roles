# Nginx Role

This Ansible role installs and configures the Nginx web server for the Corezoid platform frontend.

## Overview

The role performs the following main functions:
- Installs Nginx and related packages (corezoid-web-admin, conf-agent-client)
- Creates necessary directory structure with appropriate permissions
- Sets up branding assets (favicon, logo)
- Removes default Nginx configurations
- Deploys custom Nginx configurations for Corezoid
- Installs and configures SSL certificates
- Creates required symbolic links
- Ensures Nginx service starts automatically and survives reboots

## Requirements

- RHEL/CentOS 7/8/9 or Amazon Linux 2/2023
- Access to the AWS Corezoid repository
- Proper SSL certificate data

## Role Variables

### Required Variables for box.yml

```yaml
top_dir: "/ebsmnt"

nginx_ssl_dir: "/etc/nginx/ssl"
nginx_ssl_content: "{{ corezoid_demo_pem }}"
nginx_ssl_filename: "{{ nginx_ssl_dir }}/corezoid.pem"
nginx_limit_req: "thousand"

corezoid_release: 6.7.3

corezoid_release_app_version:
  conf-agent-client: "2.6.2"
  corezoid_web_admin: "6.7.3"

capi_endpoint: "ae-8928.middleware.biz"
superadmin_endpoint: "superadmin-ae-7682.middleware.biz"

```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-01-corezoid.com.conf.j2` - Main website configuration
- `templates/[corezoid_release]-superadmin.conf.j2` - Superadmin interface configuration
- `templates/upstream.conf.j2` - Upstream server configuration
- `templates/status.conf.j2` - Status page configuration
- `templates/cert-corezoid.j2` - SSL certificate configuration
- `templates/nginx.conf.j2` - Main Nginx configuration

## Example Playbook

```yaml
- hosts: front
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: front_capi
```

## Role Structure

```
nginx/
├── defaults/
│   └── main.yml          # Default variables   
├── files/
│   └── img/              # Default branding assets
│       ├── favicon/
│       └── logo/
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-01-corezoid.com.conf.j2    # Website configuration
│   ├── *-superadmin.conf.j2         # Superadmin configuration
│   ├── nginx.conf.j2                # Main Nginx configuration
│   ├── upstream.conf.j2             # Upstream configuration
│   ├── status.conf.j2               # Status configuration
│   └── cert-corezoid.j2             # SSL certificate template
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `front-capi-all` - Run all tasks
- `front-capi-app` - Run application-related tasks
- `front-capi-nginx-setup` - Set up Nginx
- `front-capi-nginx-package` - Install packages
- `front-capi-nginx-setup-img` - Set up branding assets
- `front-capi-nginx-setup-ssl` - Configure SSL certificates
- `front-capi-nginx-delete` - Remove default configurations
- `front-capi-nginx-configs` - Create custom configurations
- `front-capi-nginx-mainconfig` - Update main Nginx configuration
- `front-capi-nginx-symlink` - Create symbolic links
- `front-capi-nginx-system` - Manage Nginx service
- `capi-nginx-restart` - Restart Nginx service

Example:
```
ansible-playbook -i inventory playbook.yml --tags "front-capi-nginx-configs"
```

## SSL Certificate Management

The role expects an SSL certificate to be provided via the `nginx_ssl_content` variable. For security, it's recommended to store this in an encrypted vault file.

The certificate is deployed with strict permissions (0600) to ensure security.

## Conditional Features

- Superadmin static content is conditionally deployed based on the Corezoid release version
- Configuration templates are selected based on the `corezoid_release` variable, allowing for version-specific configurations

## Author

Created and maintained by Middleware