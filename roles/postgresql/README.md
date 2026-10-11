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

# optional: hosts for the pgsql_task_history section only.
# If omitted, tasks_history uses db_archive_shards (previous behaviour).
db_task_history_shards:
  - { host: "{{ db_main.host }}", user: "{{ db_main.user }}", pass: "{{ db_app_user_pass_enc }}", shards: "{{ real_db_numbers }}" }
```
### Optional Variables

```yaml
# pg_partman-managed shards (INF-29864). Default: false — omit the variable and
# the maintenance cron set stays exactly as it has always been.
# See the "Maintenance" section below for what true changes.
pg_partman_managed: false
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

`templates/maintenance.sh.j2` is deployed to `{{ db_dir }}/scripts/maintenance.sh` and scheduled
via cron. Subcommands: `truncate_all`, `truncate_tasks_history`, `partman_maintenance`,
`check_bloat`, `repack_shards`, `dbsize`, `top <db>`.

The shard list is asked of the server (`SELECT datname FROM pg_database WHERE datname ~ '${SHARD_PATTERN}'`)
instead of being assumed by brace expansion, so a shard that does not exist is left out instead of
producing connection errors. `SHARD_PATTERN` is `^cp[0-9]$` — deliberately the same ten shards the
script has always cleaned (it used `DBNAMES=$(echo cp{0..9})`). Ten production environments declare
a hundred shards in `real_db_numbers`; extending a nightly `TRUNCATE` to `cp10`–`cp99` there is a
per-environment decision, not something to inherit from a template change. Widen the pattern
consciously, and only for the environment that asked for it.

A single shard can be targeted with `DBNAME=cp3 bash maintenance.sh …`; a name that does not match
`SHARD_PATTERN` or does not exist is a FATAL. An empty shard list is treated as "list not obtained"
(server down, wrong port) and the retention functions refuse to run rather than silently doing
nothing.

**Before the first run on an existing host**, check what the script's paths and port resolve to.
`SCRIPTS`, `PG_DATA` and the psql port used to be hardcoded (`/var/lib/pgsql/scripts`, port 5433)
while the script is deployed to `{{ db_dir }}/scripts`; they are now templated from `db_dir` /
`db_version` / `db_port`. On an environment where those differ from the old hardcoded values the
retention crons have been failing (bad `cd`, or connecting to a port with no server) and this
deploy makes them actually run — verify that nightly `TRUNCATE` of `tasks_history` / `tasks_archive`
is really wanted there before running the role.

### Fail-closed TRUNCATE guard (INF-29864)

Every `TRUNCATE` goes through `truncate_table_guarded()`, which checks `pg_class.relkind` and
`pg_inherits` before touching anything:

| situation | behaviour |
| --- | --- |
| plain table, no children | `TRUNCATE ONLY` as before |
| partitioned table (`relkind='p'`) | `SKIP`, no `TRUNCATE` |
| inheritance parent (`relkind='r'` with children) | `SKIP`, no `TRUNCATE` |
| relation missing | `SKIP` |
| database unreachable / either check failed | **refusal** (non-zero rc), no `TRUNCATE` |

This matters because `TRUNCATE` on a partitioned parent wipes *all* of its partitions — on a
pg_partman-managed `tasks_archive` the old unguarded script would have destroyed the whole archive
on every shard. An inheritance parent needs the same treatment: it is an ordinary table by
`relkind`, and `TRUNCATE` without `ONLY` empties its children too.

A refusal is not swallowed: `truncate_all` / `truncate_tasks_history` keep going through the
remaining shards but return non-zero, so cron mails the failure instead of reporting success.
`TRUNCATE` runs with `lock_timeout = '5s'` — on a busy shard it gives up instead of queueing an
`ACCESS EXCLUSIVE` lock behind every other query, and the failed run shows up in the same cron mail.

The guard also makes the opt-in disk-usage guard (`disk_truncate_enabled`, which calls
`truncate_all` at 95% disk) safe on partitioned installs — but consequently ineffective for the
archive there: it will clean only `tasks_history` and `SKIP` the partitioned `tasks_archive`.
Reclaiming archive space on a partitioned host is `partman.run_maintenance()`'s retention, not
this cron's.

`truncate_all` deliberately still walks `tasks_archive`, even though that loop was removed by hand
on the pg_partman-managed host: on environments whose `tasks_archive` is a plain table that loop
*is* their retention, and on a partitioned one the guard turns it into a `SKIP`. So after a playbook
run a partitioned host prints `SKIP` once per shard — expected, not a regression.

### pg_partman mode

`pg_partman_managed: true` (set per environment in `vars/box.yml`; default `false`) switches the
cron set to the partman layout:

| cron | `pg_partman_managed: false` (default) | `pg_partman_managed: true` |
| --- | --- | --- |
| `clean history and archives` (`truncate_all`, `tasks_archive_cron_*`, default 20:00) | present | **absent** (removed by name) |
| `pg_partman maintenance (INF-29864)` (`partman_maintenance`, 03:00) | **absent** (removed by name) | present |
| `Clean history` (`truncate_tasks_history`, 21:00) | present | present |
| `check disk usage and truncate` (`check_disk_truncate.sh`, every 30 min) | opt-in via `disk_truncate_enabled`, not affected by this variable | same |

Both crons are gated by `state:`, not by `when:` — setting the variable back to `false` has to
*remove* the partman cron, and a skipped task removes nothing.

**Prerequisite:** the role neither installs the `pg_partman` extension nor creates the partition
set — that is done out of band (see the manual referenced below) and must exist *before* the
variable is set. Setting it on a host whose `tasks_archive` is not actually partitioned removes the
only archive retention while `partman_maintenance` logs `pg_partman не установлен, пропуск` for
every shard: no retention at all. Verify per shard first (`\dx pg_partman`,
`SELECT * FROM partman.part_config`).

`partman_maintenance` calls `partman.run_maintenance()` per shard, skips databases without the
`pg_partman` extension, keeps going when one database fails (but returns non-zero if any did), and
logs to `{{ db_dir }}/scripts/partman_maintenance.log` itself — so its `case` branch stays bare (an
outer `tee` would double every line). The cron sends stdout to `/dev/null` and stderr to
`{{ db_dir }}/scripts/partman_maintenance.cron.err`, so the exit status is what makes a permanently
failing `run_maintenance` visible. Neither log is rotated — watch their size on `{{ db_dir }}`.

With the variable unset, the deployed cron set is what it always was; only the script itself changes
(guard added, paths/port templated — see the deploy warning in "Maintenance" above). Enabled today
only on `ff_morocco_dev`, where the `postgresql` role is commented out in `cz-init.yml`: applying it
there needs a one-off mini-playbook next to `vars/`, a normal `run_playbook.sh` run deploys nothing.

`pg_partman_managed` is intentionally *not* declared in `defaults/main.yml` — the default lives in
the `| default(false)` filter at each use site in `tasks/install.yml`, so the other ~130
environments never evaluate a new variable. Partitioning procedure and the reference implementation
of the guard: §7 of `corezoid-partition-archive.md` in the separate **corezoid_update_manuals**
repository (branch `inf-29864-partition-tasks-archive-cp1-cp9`), not in this repo.

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