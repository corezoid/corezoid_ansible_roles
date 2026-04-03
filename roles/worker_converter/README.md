# Worker Converter Role

This Ansible role installs and configures the `worker_converter` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the worker_converter package from the Corezoid Worker Converter repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Configures Monit for service monitoring
- Ensures service starts automatically and survives reboots

## Requirements

- CentOS/RHEL 9 or Amazon Linux 2023
- Access to the `corezoid-worker-converter` repository
- Monit should be installed on the target system

## Role Variables

### Required Variables for box.yml

```yaml
top_dir: "/ebsmnt"
conf_dir: "{{ top_dir }}/conf"
app_user: "app-user"

corezoid_release_app_version:
  worker_converter: "3.0.3.1"

worker_converter:
  version: "{{ corezoid_release_app_version.worker_converter }}"
  config: "{{ conf_dir }}/worker_converter.config"

#-------------worker_converter settings----------#
worker_converter_is_enabled: "true"
wc_es_url: "https://elasticsearch.example.com/"
wc_es_index_template: "corezoid_final_tasks_$.date(%y-%m-%d)"
wc_positive_filter_conv_ids:
  - "2536"
  - "2549"
#-------------worker_converter settings----------#
```

### RabbitMQ Variables (reused from existing inventory)

The role reuses standard RabbitMQ variables already defined in `box.yml`:

| Variable | Description |
|---|---|
| `rmq[0].host` | RabbitMQ host |
| `rmq[0].port` | RabbitMQ AMQP port |
| `rmq[0].user` | RabbitMQ username |
| `rmq[0].pass` | RabbitMQ password |
| `rmq_vhost` | RabbitMQ vhost |

### Default Variables (defaults/main.yml)

| Variable | Default | Description |
|---|---|---|
| `wc_rmq_exchange` | `FinalTasksLogsExchange` | RabbitMQ exchange name |
| `wc_rmq_queue_name` | `FinalTasksLogsQ` | RabbitMQ queue name prefix |
| `wc_rmq_queues_count` | `4` | Number of queues |
| `wc_rmq_connections_per_queue` | `2` | Connections per queue |
| `wc_rmq_channels_per_connection` | `2` | Channels per connection |
| `wc_rmq_messages_prefetch` | `20` | Messages prefetch size |
| `wc_rmq_gc_queues_regexp` | `^FinalTasksLogs([0-9])+` | GC queues regexp |
| `wc_es_thread_count` | `40` | Elasticsearch thread count |
| `wc_es_timeout` | `120` | Elasticsearch timeout (seconds) |
| `wc_es_bulk_send_after_time` | `1` | Bulk flush interval (seconds) |
| `wc_es_bulk_count` | `10` | Bulk flush message count |
| `wc_memory_limit` | `2073741824` | Memory limit (bytes) |
| `wc_is_ready_port` | `8390` | Health check port |
| `wc_cluster_port` | `5567` | Erlang distribution port |

## Templates

- `templates/[worker_converter.version]-worker_converter.config.j2` - Main application configuration
- `templates/worker_converter.monit.j2` - Monit monitoring configuration

## Example Playbook

```yaml
- hosts: cz_worker_converter
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: worker_converter
```

## Role Structure

```
worker_converter/
├── defaults/
│   └── main.yml                              # Default variables
├── handlers/
│   └── main.yml                              # Event handlers
├── meta/
│   └── main.yml                              # Role metadata
├── tasks/
│   └── main.yml                              # Main tasks
├── templates/
│   ├── 3.0.3.1-worker_converter.config.j2   # Configuration template
│   └── worker_converter.monit.j2            # Monit configuration template
└── vars/
    └── main.yml                              # Internal variables
```

## Tags

- `worker-converter-all` - Run all tasks
- `worker-converter-install` - Just install the package
- `worker-converter-config` - Update configuration files
- `worker-converter-config-file` - Update only the main config file
- `worker-converter-start` - Start the service
- `worker-converter-monit` - Update Monit configuration

Example:
```
ansible-playbook -i inventory playbook.yml --tags "worker-converter-config"
```

## Author

Created and maintained by Middleware
