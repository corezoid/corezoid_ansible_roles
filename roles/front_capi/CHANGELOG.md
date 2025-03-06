# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-06

### Added
- Initial version of the Nginx role
- Automatic installation of Nginx and related packages (corezoid-web-admin, conf-agent-client) from AWS Corezoid repository
- Creation of directory structure for branding assets and SSL certificates
- Deployment of default branding assets (favicon, logo)
- Removal of default Nginx configurations
- Creation of custom Nginx configurations for Corezoid platform
- Installation and setup of SSL certificates with secure permissions
- Creation of required symbolic links
- Setup of automatic service startup and restart options
- Complete documentation in README.md format (in Russian and English)
- Tags for flexible execution of individual parts of the role

### Changed
- Optimized role structure for better readability and maintenance
- Consolidated package installation tasks into a single task with a loop
- Consolidated directory creation tasks into a single task with a loop
- Consolidated configuration file creation tasks using templates

### Fixed
- Proper permission management for configuration and SSL files
- Secure handling of SSL certificates and private keys