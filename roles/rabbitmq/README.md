# Ansible Role: RabbitMQ

Ansible role for installing and configuring RabbitMQ with clustering support.

## Supported Platforms

- CentOS 7, 8, 9
- Red Hat Enterprise Linux 7, 8, 9
- Oracle Linux 7, 8, 9
- Amazon Linux 2023 (x86_64, aarch64)
- Amazon Linux 2

## Requirements

- Ansible 2.13.5 or higher
- Root privileges on target servers
- Access to RabbitMQ, Erlang, and Socat RPM packages

## Role Variables

### Required Variables for box.yml

```yaml
# Version control
rmq_version: "3.12.2" # version may change see changelog
rmq_erl_version: "26.0.2" # version may change see changelog

# Virtual hosts configuration
rmq_vhost: "/conveyor"

rmq_host: "127.0.0.1"
rmq_port: 5672
rmq_user: "app-user"
rmq_user_pass: "{{ rmq_app_user_pass_enc }}"
rmq_admin_pass: "{{ rmq_admin_pass_enc }}"
rabbitmq_create_cluster: false

rmq:
   - { host: "{{ rmq_host }}", port: "{{ rmq_port }}", user: "{{ rmq_user }}", pass: "{{ rmq_app_user_pass_enc }}", vhost: "{{ rmq_vhost }}", shards: "{{ real_db_numbers }}", dns_cache_name: "name1" }

rmq_http:
   - { host: "{{ rmq_host }}", port: "{{ rmq_port }}", user: "{{ rmq_user }}", pass: "{{ rmq_app_user_pass_enc }}", vhost: "{{ rmq_vhost }}", dns_cache_name: "name5" }

rmq_core:
   - { host: "{{ rmq_host }}", port: "{{ rmq_port }}", user: "{{ rmq_user }}", pass: "{{ rmq_app_user_pass_enc }}", vhost: "{{ rmq_vhost }}", shards: "{{ real_db_numbers }}", dns_cache_name: "name1" }


```

### Required Variables for box-credential.yml example

```yaml
rmq_app_user_pass_enc: "Roo2ieX9ahS7sie" 
rmq_admin_pass_enc: "eerie8weifee3iC" 
rmq_cluster_cookie: "FXQJFCEEOAL5FOCFUSVVPQ1F"
```


## Tags

- `rabbit-all`: All role tasks
- `rabbit-install`: Package installation only
- `rabbitmq-install-cookie`: Erlang cookie configuration
- `rabbitmq-set-pass`: User and password management
- `rabbitmq-add-vhost`: Virtual host management
- `rabbitmq-add-users`: User management
- `rabbitmq-plugins`: Plugin management
- `rabbitmq-policy`: HA policy configuration
- `rabbitmq-cluster`: Clustering configuration

## Usage Examples

### Basic Installation

```yaml
 - hosts: cz_rabbit
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - role: rabbitmq
```

### Cluster Setup

```yaml
 - hosts: cz_rabbit
   become: true
   vars_files:
      - vars/box.yml
      - vars/box-credentials.yml
   roles:
    - { role: rabbitmq, rabbitmq_create_cluster: true, rabbitmq_cluster_master: "rabbit-1",
        rabbitmq_cluster_nodes: [
          {
            ip: "10.60.101.63",
            hostname: "rabbit-1"
          },
          {
            ip: "10.60.101.132",
            hostname: "rabbit-2"
          }
        ]
      }
```

## Role Structure

```
rabbitmq/
├── defaults/
│   └── main.yml          # Default variables
├── files/
│   ├── rabbitmq-*.rpm    # RabbitMQ packages
│   ├── erlang-*.rpm      # Erlang packages
│   └── socat-*.rpm       # Socat packages
├── templates/
│   ├── erlang.cookie.j2  # Erlang cookie template
│   ├── rabbitmq.config.j2 # RabbitMQ configuration
│   ├── limits.conf.j2    # Resource limits
│   └── enabled_plugins.j2 # Plugins configuration
└── tasks/
    └── main.yml          # Main tasks
```

## Features

- Multi-distribution support
- Automated cluster configuration
- High availability policy setup
- Virtual host management
- User management with different privilege levels
- Plugin management
- System limits configuration

## Clustering Features

- Automated cluster node discovery
- Port connectivity checks (4369, 5672, 15672)
- Automatic hostname configuration
- Master/slave node setup
- Cluster status verification

## Troubleshooting

### Common Issues

1. Cluster formation issues:
    - Check network connectivity between nodes
    - Verify port accessibility
    - Ensure consistent Erlang cookie across nodes
    - Check node hostnames resolution

2. Package installation errors:
    - Verify package presence in files directory
    - Check version compatibility
    - Ensure all dependencies are met

3. Permission issues:
    - Check Erlang cookie permissions (0400)
    - Verify RabbitMQ configuration file permissions
    - Ensure correct ownership of directories

## Author Information

Created and maintained by Middleware