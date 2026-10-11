# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-04

### Added
- Initial version of the Ansible role for installing and configuring the corezoid_limits service
- Installation of the corezoid_limits package from the AWS Corezoid repository
- Creation of necessary directories with appropriate permissions
- Configuration file setup from template
- Monitoring setup via Monit
- Tags for flexible execution control of various role tasks
- Documentation (README.md) with role description, variables, and usage examples

### Changed
- Optimized directory creation using loop
- Improved tag structure for more flexible task management

### Fixed
- Fixed permission issues for configuration files