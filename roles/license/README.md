# Ansible Role: License

This Ansible role deploys a license to the server.

## Requirements

- Ansible version 2.13.5 or higher
- Target systems running:
    - RHEL/CentOS 7, 8, or 9
    - Amazon Linux 2 or 2023

## Role Variables

The following variables are used by this role:


### Required Variables

- `app_user`: The user under which the license server will run
- `license_file_path`: Path where license certificates will be stored
- `license_file_name`: Name of the license file to be deployed
- `ls_local_filedir`: Local directory containing the license files
- `license_as_file`: Boolean flag to determine if license should be deployed as a file (default: true)

### Required Variables for box.yml

```yaml
license_as_file: "true"
license_file_path: "{{ top_dir }}/certs"
license_file_name: "licence"
ls_local_filedir: "files"
```

## Dependencies

This role has no dependencies on other Ansible roles.

## Example Playbook

```yaml
 - hosts: cz_all
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - role: license
```

## Role Structure

```
license-server/
├── defaults/
│   └── main.yml         # Default variables
├── handlers/
│   └── main.yml         # Handler definitions
├── tasks/
│   └── main.yml         # Main task file for license deployment
├── vars/
│   └── main.yml         # Role-specific variables
└── README.md            # This file
```

## Functionality

The role performs the following main tasks:

1. Creates a secure directory for storing license certificates
2. Sets appropriate ownership and permissions (0755) for the license directory
3. Deploys license files with secure permissions (0644)
4. Supports Corezoid 6.x license file deployment


## Author Information

Created by Middleware Inc.

For support or questions about this role, please contact Middleware Inc.