# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-06

### Added
- Initial version of the CAPI role for Corezoid platform
- Installation of CAPI package from AWS Corezoid repository
- Creation and configuration of all necessary directories with proper permissions
- Optimized static resource management (avatars)
- Configuration file template with complete set of variables
- Integration with Monit monitoring system
- Setup for automatic startup and recovery after reboot
- Tagging system for flexible task execution
- Detailed documentation with usage examples

### Features
- Enhanced approach to directory creation using task blocks
- Idempotent handling of static resources
- Use of service_name variable to improve flexibility and maintainability
- Full compatibility with Corezoid infrastructure

### Supported Platforms
- RHEL/CentOS 7, 8, 9
- Amazon Linux 2
- Amazon Linux 2023
