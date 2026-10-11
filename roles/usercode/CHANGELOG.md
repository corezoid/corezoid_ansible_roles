# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-10-08

### Added
- Assert that `/etc/yum.repos.d/corezoid-prod.repo` exists before installing; fails with a message pointing to `role: yum` instead of a cryptic dnf "No package" / GPG error (INF-30520)
- Variable `usercode_install_legacy_libcrypto` gates the `libcrypto.so.1.0.0` copy

### Fixed
- `libcrypto.so.1.0.0` is copied on every RHEL-family 8 host (RHEL/Rocky/Alma/Oracle) for releases < 6.14.0 — before, only OracleLinux 8 got it and usercode 6.13.0 failed to boot elsewhere on EL8 ("Failed to load NIF library ... libcrypto.so.1.0.0"). Not copied for OTP 28 releases (>= 6.14, OpenSSL linked statically) or on EL9

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
