# Changelog

All notable changes to this Redis role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-02-12

### Added
- Initial role release
- Redis 7.2.4 installation support for multiple platforms
- Multiple instance support (counter, cache, timers)
- Systemd service configuration
- Resource limits configuration
- Monit monitoring integration
- Configuration templates for each instance type
- Support for CentOS, RHEL, Oracle Linux and Amazon Linux
- Directory structure setup with proper permissions
- Service management and autostart configuration
- Basic monitoring configuration
- Documentation and usage examples

### Notes
- Requires Ansible 2.13.5 or higher
- Supports only Redis 7.2.4
- Requires root privileges on target servers
- Requires pre-installed Monit for monitoring features