# Ansible Role: YUM Repository Management

Ansible role for managing YUM repositories on RHEL-based systems custom repository configuration.

## Supported Platforms

- Enterprise Linux (RedHat/CentOS/OracleLinux) 7, 8, 9
- Amazon Linux 2
- Amazon Linux 2023

## Requirements

- Ansible version 2.13.5 or higher
- Internet access for package downloads
- Root access for package installation

## Role Variables

### Main Variables
```yaml
yum_s3_bucket_prefix:                        # Path prefix in S3 bucket, examples:
- "{{ corezoid_release }}/amazon2/arm64"   # Amazon Linux 2 ARM64
- "{{ corezoid_release }}/amazon2/latest"  # Amazon Linux 2 x86_64
- "{{ corezoid_release }}/amazon2023/arm64"  # Amazon Linux 2023 ARM64
- "{{ corezoid_release }}/amazon2023/latest" # Amazon Linux 2023 x86_64
- "{{ corezoid_release }}/redhat/7"        # RHEL/CentOS 7
- "{{ corezoid_release }}/redhat/8"        # RHEL/CentOS 8
- "{{ corezoid_release }}/redhat/9"        # RHEL/CentOS 9
```
### Basic Installation
```yaml
 - hosts: cz_all
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
      - { role: yum,
         yum_s3_bucket: "corezoid",
         yum_s3_bucket_prefix: "{{ corezoid_release }}/amazon2023/arm64" }
```

## Tags

- `yum-all`: Execute all role tasks
- `yum-debug`: Show system information
- `yum-corezoid-repo`: Install Corezoid repository only
- `getdist`: Show distribution information

## Diagnostics

The role includes extended system information output that can be accessed using the `yum-debug` tag:

- Hostname
- IP address
- CPU count
- Memory size
- Distribution information
- OS version

## Author

Created and maintained by Middleware Inc.
