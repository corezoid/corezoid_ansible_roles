# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-02

### Added
- Initial version of the Worker Converter role
- Automatic installation of the worker_converter package from `corezoid-worker-converter` repository
- Support for CentOS 9 (x86_64) and Amazon Linux 2023 (arm64)
- Creation of all necessary directories for service operation
- Versioned configuration file template (`3.0.3.1-worker_converter.config.j2`)
- Elasticsearch bulk-indexing producer configuration
- RabbitMQ consumer configuration reusing shared `rmq[0]` inventory variables
- `positive_filter_data` support via `wc_positive_filter_conv_ids` list variable
- Setup of automatic service startup
- Monit monitoring configuration
- Tags for flexible execution of individual parts of the role
- Complete documentation in README.md format
