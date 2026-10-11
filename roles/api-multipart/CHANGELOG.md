# Changelog

All notable changes to the Conveyor API Multipart role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-03

### Added
- Initial release of the Conveyor API Multipart role
- Support for RHEL/CentOS 7/8/9 and Amazon Linux 2/2023
- Installation of conveyor_api_multipart package from AWS Corezoid repository
- Directory structure creation with proper permissions
- Configuration file templating with secure permissions
- Monit monitoring configuration
- Support for multiple tags for selective execution
- Documentation 

### Changed
- Refactored from legacy playbook to proper Ansible role structure
- Improved directory creation process using loops for better efficiency
- Combined configuration generation and permission setting tasks
- Added consistent variable naming convention

### Fixed
- Added proper error handling for package installation
- Fixed permissions on configuration files
- Added compatibility with various OS versions