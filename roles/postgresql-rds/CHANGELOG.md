# Changelog

All notable changes to this PostgreSQL RDS role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-02-19

### Added
- Initial role release
- PostgreSQL RDS database creation and configuration
- User and role management system
- Schema deployment for main and shard databases
- Password hashing and security features
- FDW (Foreign Data Wrapper) configuration
- Multiple database instance support (main and shards)
- Secure privilege management system
- Async schema deployment with performance optimization
- Support for PostgreSQL extensions (postgres_fdw, pgcrypto)
- Payment plan initialization for conveyor database
- Documentation and usage examples

## [1.1.0] - 2025-04-02
### Added
- New dedicated database corezoid_counters with specialized tables structure

### Notes
- Requires Ansible >2.17.0 
- Requires root privileges on target servers
- Requires local machine setup with Python 3.6+ and psycopg2
- Requires configured .pgpass file with proper permissions
- Requires RDS access on port 5432