# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-05

### Added
- Initial release of the usercode role
- Installation of the usercode package from AWS Corezoid repository
- Creation of necessary directories with appropriate permissions
- Application configuration with a secure configuration file
- Deployment of JavaScript libraries (moment-timezone.js, sha256.js, sha512.js, hex.js)
- Installation of SSL support library for Oracle Linux 8 environments
- Configuration of secure permissions for application files
- Monit monitoring setup
- Ensuring service starts automatically on system reboot
- Complete set of tags for selective task execution
- Detailed documentation in README.md describing all functions, variables, and requirements

### Optimized
- Consolidated directory creation tasks for improved efficiency
- Usage of the service_name variable for better uniformity and maintainability
- Improved JavaScript library management using variables and loops
- Optimized task structure for better readability and maintenance