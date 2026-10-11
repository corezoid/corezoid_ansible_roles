# Changelog

All notable changes to the `conf_agent_server` role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-04

### Added
- Initial release of the `conf_agent_server` role
- Support for installation from AWS Corezoid repository
- Creation of required directory structure with proper permissions
- Configuration from template with version-specific options
- Monit monitoring integration for service supervision
- Documentation in README.md file

### Changed
- Refactored directory creation to use a loop for better efficiency
- Standardized tag naming convention to `conf_agent_server-*`

### Security
- Set proper file permissions (0700) for application directories
- Restricted configuration file permissions (0500)
- Proper ownership of all application files and directories