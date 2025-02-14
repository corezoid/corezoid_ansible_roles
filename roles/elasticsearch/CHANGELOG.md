# Changelog

All notable changes to this Elasticsearch role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
