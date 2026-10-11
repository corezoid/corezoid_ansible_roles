# Changelog
All notable changes to this role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-10-08

### Added
- `yum_s3_bucket_prefix` is derived from facts when not set (`<release>/redhat/<major>`, Amazon 2/2023 with arch); explicit values still win
- EPEL for every RHEL-family flavour: CentOS/Rocky/Alma (`epel-release` + CRB/PowerTools), Oracle Linux (`oracle-epel-release-elN` + `olN_codeready_builder`), RHEL proper (fedoraproject rpm + `subscription-manager` CRB, non-fatal without subscription). Variables `yum_enable_epel`, `yum_rhel_crb_fail_fatal`
- Import of the Middleware GPG key (`rpm_key`) when `gpgcheck=1`
- EL9 package-signature preflight (`tasks/preflight_el9.yml`): downloads one package from `aws-corezoid`, reads the signature digest, fails with a readable message when the repository is RSA/SHA1-signed and the host crypto policy is DEFAULT/FUTURE. Documented emergency override `corezoid_allow_sha1_policy: true` (applies `DEFAULT:SHA1` with a warning). Variables `corezoid_repo_preflight`, `corezoid_repo_preflight_package`
- Tags `yum-preflight`

### Changed
- README rewritten: supported flavours (Rocky/Alma), derived prefix, EL9 SHA1 section, example play with `role: yum` in every application play

## [1.0.0] - 2025-02-14

### Added
- Initial release of the yum role
- Corezoid repository configuration:
  - Amazon Linux 2 (arm64/x86_64)
  - Amazon Linux 2023 (arm64/x86_64)
  - RHEL/CentOS 7,8,9
- System information debugging capabilities
- Documentation (README.md)

### Changed
- Updated minimum Ansible version requirement to 2.13.5

### Dependencies
- None in initial release
