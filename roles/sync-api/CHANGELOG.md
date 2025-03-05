# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-05

### Added
- Initial release of the `corezoid_api_sync` role
- Installation and configuration of the `corezoid_api_sync` service from AWS Corezoid repository
- Creation of required directories with proper permissions
- Generation of configuration file from template
- Service management (start, enable on boot)
- Monitoring setup via Monit
- Installation and configuration of Nginx as a reverse proxy for the API
- SSL configuration using provided certificates
- Upstream blocks configuration for load balancing
- Documentation with usage examples and configuration guidance
- Tagging system for flexible execution of role components

### Release Features
- Optimized task structure using blocks and loops
- Full support for RHEL/CentOS 7/8/9 and Amazon Linux 2/2023
- Security setup with minimal required permissions
- Detailed comments for all tasks