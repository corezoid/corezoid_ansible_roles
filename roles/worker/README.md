# Worker Role

This Ansible role installs and configures the `worker` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the worker package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Configures the application with a secure configuration file
- Configures Monit for service monitoring
- Ensures service starts automatically and survives reboots

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
  worker: "5.2.1.1"

worker:
  version: "{{ corezoid_release_app_version.worker }}"
  config: "{{ conf_dir }}/worker.config"

#-------------worker.config settings----------#
worker_max_task_size: 3145728
worker_max_task_size_for_process_conv: "{{ worker_max_task_size }}"
worker_max_task_size_for_st_diagramm_conv: "{{ worker_max_task_size }}"
worker_public_callback_prefix: "https://{{ capi_endpoint }}"
pub_arc_pool_min: 20
pub_arc_pool_max: "{{ pub_arc_pool_min }}"
pub_arc_pool_start: "{{ pub_arc_pool_min }}"

cons_copy_task_connections_per_queue: 1
cons_copy_task_channels_per_connection: 1
cons_copy_task_msg_prefetch_size: 50

cons_timers_conn_per_queue: 1
cons_timers_channels_per_connection: 1
cons_timers_msg_prefetch_size: 50

cons_http_connections_per_queue: 10
cons_http_channels_per_connection: 5
cons_http_msg_prefetch_size: 50

cons_arc_conn_per_queue: 5
cons_arc_channels_per_connection: 2
cons_arc_msg_prefetch_size: 1000
cons_arc_workers: 20

pub_http_pool_min: 20
pub_http_pool_max: "{{ pub_http_pool_min }}"
pub_http_pool_start: "{{ pub_http_pool_min }}"

pub_rpc_queues_count: 1

cons_rpc_connections_per_queue: 5
cons_rpc_channels_per_connection: 1
cons_rpc_msg_prefetch_size: 50

pub_cce_queues_count: 4
pub_cce_pool_min: 30
pub_cce_pool_max: "{{ pub_cce_pool_min }}"
pub_cce_pool_start: "{{ pub_cce_pool_min }}"

cons_cce_connections_per_queue: 5
cons_cce_channels_per_connection: 2
cons_cce_msg_prefetch_size: 50

cons_get_task_connections_per_queue: 1
cons_get_task_channels_per_connection: 1
cons_get_task_msg_prefetch_size: 50

cons_settings_connections_per_queue: 1
cons_settings_channels_per_connection: 1
cons_settings_msg_prefetch_size: 50

pub_to_worker_pool_min: 5

cons_shard_connections_per_queue: 10
cons_shard_channels_per_connection: 5
cons_shard_msg_prefetch_size: 50

worker_hosts:
  - { host: "" }
worker_cluster_port: 5566

plugins_unload_archive_task: false

pg_conn_pool_start: 5
pg_conn_pool_min: 5
pg_conn_pool_max: 50

pg_conn_pool_history_start: 2
pg_conn_pool_history_min: 2
pg_conn_pool_history_max: 50
#-------------worker.config settings----------#
```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-worker.config.j2` - Main application configuration
- `templates/worker.monit.j2` - Monit monitoring configuration

## Example Playbook

```yaml
- hosts: cz_worker
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: worker
```

## Role Structure

```
worker/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-worker.config.j2    # Configuration templates
│   └── worker.monit.j2       # Monit configuration template
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `worker-all` - Run all tasks
- `worker-install` - Just install the package
- `worker-config` - Update configuration files
- `worker-config-file` - Update only the main config file
- `worker-start` - Start the service
- `worker-monit` - Update Monit configuration

Example:
```
ansible-playbook -i inventory playbook.yml --tags "worker-config"
```

## Author

Created and maintained by Middleware