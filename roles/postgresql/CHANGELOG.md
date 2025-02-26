# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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