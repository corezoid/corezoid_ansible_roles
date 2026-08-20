# PostgreSQL Ansible Role

This Ansible role installs and configures PostgreSQL database servers with optimized settings for production environments. The role supports multiple distributions including RHEL/CentOS, Oracle Linux, and Amazon Linux.

## Features

- Multi-distribution support (RHEL/CentOS 7/8/9, Oracle Linux, Amazon Linux 2/2023)
- Installation and configuration of PostgreSQL 13 and 15
- Database initialization and schema deployment
- User and role management
- Connection pooling with PgBouncer
- Automated maintenance scripts and scheduling
- Support for sharded database deployments
- Foreign Data Wrapper (FDW) configuration

## Requirements

- Ansible 2.13.5
- Root privileges on target servers
- Target servers with supported Linux distributions

## Role Variables

### Required Variables for box.yml

```yaml
top_db_dir: "/postgresqldata"
db_dir: "{{ top_db_dir }}/pgsql"
app_user: "app-user"
shards: [0,1,2,3,4,5,6,7,8,9]
shards_numbers: [0,1,2,3,4,5,6,7,8,9]
shards_count: "{{ shards_numbers|length }}"
real_db_numbers: [0,1,2,3,4,5,6,7,8,9]
shards_numbers_on_db_1: "{{ real_db_numbers }}"

corezoid_release: "6.7.3"

db_version: "15"
db_ver: "15"
pgbouncer:
  port: 5432
db_huge_pages: false
db_superuser_login: "postgres"
db_superuser_password: "{{ db_superuser_password_enc }}"
db_port: 5433
db_viewers:
  - ""

db_main:
  host: "127.0.0.1"
  port: "{{ db_port }}"
  user: "internal_user"
  pass: "{{ db_app_user_pass_enc }}"

db_app_user: "{{ db_main.user }}"
db_fdw_user: "fdw_user"

db_shards:
  - { host: "{{ db_main.host }}", user: "{{ db_main.user }}", pass: "{{ db_app_user_pass_enc }}", shards: "{{ real_db_numbers }}" }

db_archive_shards:
  - { host: "{{ db_main.host }}", user: "{{ db_main.user }}", pass: "{{ db_app_user_pass_enc }}", shards: "{{ real_db_numbers }}" }
```
### Required Variables for box-credential.yml example

```yaml
db_superuser_password_enc: "asho7Yutoopheek7"
db_app_user_pass: "okuiNgie5Gohnie3p"
db_app_user_pass_enc: "okuiNgie5Gohnie3p"
db_monitoring_user_password: "kuiNgie5Gohnie3p"
db_fdw_user_pass: "oot8boY6OhXooleo"
db_fdw_user_pass_enc: "oot8boY6OhXooleo"
```

## Example Playbook

```yaml
---
 - hosts: cz_db
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
      - role: postgresql
```

## Directory Structure

```
postgresql/
├── defaults/          # Default variable values
├── files/             # Static files and SQL schemas
│   ├── 6.x.x/         # Version-specific schema files
│   │   └── init/      # Database initialization SQL files
├── handlers/          # Handlers for service restarts
├── meta/              # Role metadata
├── tasks/             # Task definitions
│   ├── add_repo.yml              # Repository configuration
│   ├── add_users_to_viewers.yml  # Viewer user creation
│   ├── create_db_from_postgres_fdw.yml  # FDW configuration
│   ├── create_db_from_schema.yml  # Schema deployment
│   ├── install.yml               # PostgreSQL installation
│   ├── main.yml                  # Main entry point
│   └── pgbouncer.yml             # PgBouncer configuration
├── templates/         # Jinja2 templates for configuration files
├── tests/             # Test playbooks
└── vars/              # Variable definitions
```

## Database Schema Deployment

The role deploys database schemas from SQL files stored in the `files/<version>/init/` directory. It supports different schema versions and handles both main application databases and shard databases.

Main databases include:
- conveyor
- cce
- health_check
- conveyor_statistics
- git_call
- settings
- accounts
- limits

Shard databases follow the pattern `cp<number>` and are created based on the `real_db_numbers` variable.

## Connection Pooling

The role configures PgBouncer as a connection pooler with proper authentication and resource limits. PgBouncer is installed and configured with:

- MD5 password authentication
- User-specific connection pools
- Optimized systemd service configuration
- Separate user list file

## Maintenance

Automated maintenance scripts are deployed and scheduled via cron jobs for:
- Periodic database cleanup
- Task history truncation
- Archive cleanup

## Tags

Use tags to run specific parts of the role:

- `postgresql-all`: All PostgreSQL tasks
- `postgresql-repo`: Repository configuration only
- `postgresql-install-packages`: Package installation only
- `postgresql-config-files`: Configuration file deployment only
- `postgresql-maintenance`: Maintenance scripts and schedules only
- `postgresql-pgbouncer`: PgBouncer configuration only
- `pgsql-deploy-schema`: Schema deployment only

## Author Information

Created and maintained by Middleware