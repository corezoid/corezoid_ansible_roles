# Changelog

All notable changes to this role will be documented in this file.

## [Unreleased] - 2026-10-08

### Fixed
- Rocky Linux / AlmaLinux: `monit_rpm_file` lookup no longer fails with an undefined-key error — RHEL-family flavours share the `RedHat-<major>-<arch>` entries; added `RedHat-9-aarch64`
- SELinux, `kernel.sem` sysctl and python36 tasks run on every RHEL-family flavour (previously CentOS/RedHat/OracleLinux only)
- EPEL on Oracle Linux 8/9 and CentOS/Rocky/Alma 8/9 via the dnf module (idempotent); role `yum` is the primary place for EPEL now
