# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-05

### Added
- Initial version of the Worker role
- Automatic installation of the Worker package from AWS Corezoid repository
- Creation of all necessary directories for service operation
- Configuration file generation based on template
- Setup of automatic service startup
- Addition of monitoring through Monit
- Complete documentation in README.md format
- Tags for flexible execution of individual parts of the role

### Changed
- Optimized role structure for better readability and maintenance
- Consolidated directory creation tasks into a single task with a loop

### Fixed
- Proper permission management for configuration files

## [1.1.0] - 2025-04-02

### Added
- added block corezoid_counters_internal for capi.config