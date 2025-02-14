# Changelog

All notable changes to this RabbitMQ role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-02-13

### Added
- Initial role release
- RabbitMQ 3.12.2 and Erlang 26.0.2 installation support
- Clustering support with automatic configuration
- Cluster ports verification (4369, 5672, 15672)
- Automatic /etc/hosts entries management for cluster nodes
- Virtual hosts configuration (conveyor, gitcall, dbcall, dundergitcall)
- User management with different access levels
- High availability policies setup for all vhosts
- Erlang cookie configuration for cluster authentication
- RabbitMQ plugins management
- Service autostart configuration
- Support for CentOS, RHEL, Oracle Linux and Amazon Linux
- Complete documentation with usage examples

### Notes
- Requires Ansible 2.13.5 or higher
- Supports only RabbitMQ 3.12.2 and Erlang 26.0.2
- Requires root privileges on target servers
- Special handling for Amazon Linux 2023 aarch64
- All configuration files are created with proper permissions
- Support for all major RabbitMQ operations through tags
- Capability to deploy both single node and cluster setups