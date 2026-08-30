# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### Optimized
- Consolidated duplicate tasks for improved performance
- Structured tasks into logical groups for better management
- Parameterized all values for flexible configuration
- Added detailed task comments for easier understanding and maintenance

### Security
- Secure database access configuration via pg_hba.conf
- Proper file permission management to protect data
- Encrypted passwords for database users
- PgBouncer configuration with secure authentication

## [1.0.0] - 2025-02-26

### Added
- Initial release of PostgreSQL role with support for:
    - Installation and configuration of PostgreSQL 13 and 15
    - Automatic repository setup for various distributions
    - Support for RHEL/CentOS 7/8/9, Oracle Linux, and Amazon Linux 2/2023
    - Automatic database initialization
    - Performance-optimized configurations
    - Role and user creation with proper permissions
    - Schema deployment from SQL files
    - Foreign Data Wrapper (FDW) configuration for distributed queries
    - PgBouncer installation and configuration for connection pooling
    - Automated maintenance scripts and cron jobs

## [1.1.0] - 2025-04-02
### Added
- New dedicated database corezoid_counters with specialized tables structure

## [1.2.0] - 2025-09-23
### Added
- Added libs for Amazon 2023
 ``` 
  pg_repack_15
  pg_pglogical_15
  pglogical_llvmjit_15
  ```

## [1.3.0] - 2026-08-24
### Security
- `maintenance.sh`: every `TRUNCATE` now goes through a fail-closed guard
  (`truncate_table_guarded`) — a partitioned table is SKIPped, an inheritance parent is SKIPped,
  an unreachable database is a refusal, and the statement itself is `TRUNCATE ONLY`. Prevents
  `TRUNCATE tasks_archive` from wiping all partitions of a pg_partman-managed archive (INF-29864)

### Added
- `maintenance.sh partman_maintenance` — per-shard `partman.run_maintenance()`, skips databases
  without the `pg_partman` extension, own log `{{ db_dir }}/scripts/partman_maintenance.log`
- `pg_partman_managed` (default `false`): when `true`, removes the `clean history and archives`
  (`truncate_all`) cron and adds the `pg_partman maintenance (INF-29864)` cron at 03:00.
  With the variable unset the cron set is unchanged

### Fixed
- `maintenance.sh`: `SCRIPTS`, `PG_DATA` and the psql port were hardcoded (`/var/lib/pgsql/scripts`,
  port 5433) while the script is deployed to `{{ db_dir }}/scripts` — now templated from
  `db_dir` / `db_version` / `db_port`
- shard list comes from `pg_database` instead of `cp{0..9}` brace expansion, so a shard that does
  not exist is skipped instead of erroring; the pattern (`SHARD_PATTERN='^cp[0-9]$'`) keeps the
  historical ten-shard scope on purpose — see the deploy note below. `DBNAME=` override is
  validated against the same pattern, an empty list is a refusal
- retention and `partman_maintenance` now return non-zero when any shard failed (previously a
  refusal, a `lock_timeout` and a failed `run_maintenance` all reported success to cron)
- the wraparound-autovacuum cancel is skipped when the table's name could not be resolved
  (the `LIKE` would otherwise match any wraparound autovacuum in the database and could cancel an
  unrelated one, or return several pids and produce invalid SQL); the lookup is `limit 1`
- `check_bloat` / `repack_shards` refuse on an empty shard list instead of looping zero times
- `dbsize` added to the usage line

### Deploy note
This release changes what the script *does* on hosts where it has been silently broken: the paths
and port fixes make the retention crons connect and run where they previously could not, and the
role's own `Add maintenance.sh` overwrites any hand-edited copy on the host. Before running the
role on an environment that has not been reconciled recently, check the resulting `maintenance.sh`
and confirm that a nightly `TRUNCATE` of `tasks_history` / `tasks_archive` is wanted there.
