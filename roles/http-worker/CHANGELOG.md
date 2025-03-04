# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-04

### Added
- Initial release of the http-worker role
- Installation of the http-worker package from AWS Corezoid repository
- Creation of required directories with appropriate permissions
- Service configuration using configuration templates
- Automatic startup and enabling of the service on boot
- Monitoring setup via Monit
- Task tagging for selective execution

### Technical Improvements
- Refactoring to use service_name and service_config_name variables
- Consolidation of directory creation tasks into a single task with a loop
- Usage of modern YAML format for tasks
- Optimization of task tagging for greater flexibility

### Security
- Application of secure access permissions to configuration files (mode 0500)
- Setting secure permissions for the application directory (mode 0700)
- Proper management of file ownership for the application user