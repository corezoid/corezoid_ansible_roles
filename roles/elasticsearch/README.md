# Ansible Role: Elasticsearch

Ansible role for installing and configuring Elasticsearch with support for various distributions and versions.

## Supported Platforms

- CentOS 7, 8, 9
- Red Hat Enterprise Linux 7, 8, 9
- Oracle Linux 7, 8, 9
- Amazon Linux 2023 (x86_64, aarch64)
- Amazon Linux 2

## Requirements

- Ansible 2.13.5 or higher
- Root privileges on target servers
- Java 11 or higher

## Role Variables

### Required Variables for box.yml

```yaml

elasticsearch:
  version: "8.13" # version may change see changelog
  es_mastername: "127.0.0.1"
  es_main_dir: "elasticsearch"
  es_dir_owner: "elasticsearch"
  es_cluster_list: "127.0.0.1"
  heap_size: "2g" # ram allocation parameter
  elastic_username: "elastic"
  elastic_password: "Corezidtest"

```

## Tags

- `elasticsearch-all`: All role tasks
- `elasticsearch-install`: Package installation only
- `elasticsearch-repo-install`: Repository configuration
- `elasticsearch-install-main-dir`: Directory setup
- `elasticsearch-nginx-setup`: Nginx configuration
- `elasticsearch-monit`: Monitoring configuration
- `elasticsearch-security` : Add password elasticsearch


## Usage Examples

### Basic Installation

```yaml
- hosts: cz_elastic
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: elasticsearch
```
## Role Structure

```
elasticsearch/
├── defaults/
│   └── main.yml          # Default variables
├── handlers/
│   └── main.yml          # Service handlers        
├── templates/
│   ├── elasticsearch.yml.j2    # ES configuration
│   ├── jvm.options.j2          # JVM settings
│   ├── nginx.conf.j2           # Nginx configuration
│   ├── es.conf.j2             # ES-specific Nginx config
│   └── elasticsearch.monit.j2  # Monit configuration
└── tasks/
    └── main.yml          # Main tasks
```

## Features

- Multi-distribution support
- Automated Java installation
- Nginx reverse proxy configuration
- Monit monitoring setup
- JVM optimization
- System limits configuration

## Configuration Features

- Nginx reverse proxy with rate limiting
- Monit health checks
- System resource limits

## Troubleshooting

### Common Issues

1. Java Installation Issues:
    - Verify Java version compatibility
    - Check repository access
    - Ensure correct distribution detection

2. Memory Configuration:
    - Verify system has enough RAM
    - Check heap size settings
    - Monitor for OOM errors

3. Permission Issues:
    - Check directory ownership
    - Verify file permissions
    - Ensure correct SELinux context

4. Nginx Configuration:
    - Verify port availability
    - Check proxy settings
    - Monitor error logs

### Monitoring

The role configures Monit to monitor Elasticsearch:
- HTTP endpoint health check
- Process monitoring
- Resource usage alerts

## Author Information

Created and maintained by Middleware

