# Changelog

All notable changes to this Elasticsearch role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-10-08

### Changed
- Java install runs on every RHEL-family flavour (Rocky/Alma included)
- `update-crypto-policies --set DEFAULT:SHA1` on EL9 is now opt-in (`elasticsearch_set_sha1_policy: true`). Its side effect (letting SHA1-signed Corezoid RPMs install) is replaced by the explicit preflight/override in role `yum`

## [1.1.q] - 2025-09-03
### Added
- support only 8.19 version box.yaml


## [1.1.0] - 2025-08-13
### Added
- Password elasticserarch

## [1.0.0] - 2025-02-14

### Added
- Initial role release
- Support for Elasticsearch 8.13.4 installation
- Automatic Java 11 installation and configuration
- Support for CentOS, RHEL, Oracle Linux and Amazon Linux 
- Nginx configuration as reverse proxy
- Monit configuration for monitoring
- System limits management
- Flexible JVM configuration via jvm.options
- Automatic directory and permissions setup
- Complete documentation with usage examples

### Notes
- Requires Ansible 2.13.5 or higher
- Supports only Elasticsearch 8.13
- Requires root privileges on target servers
- All configuration files are created with proper permissions
- Support for all major operations through tags
- Capability to deploy both single node and cluster setups
