# Ansible Role: PostgreSQL RDS

Ansible role for configuring and managing PostgreSQL databases with main and shard instances.

## Requirements

- Ansible 2.13.5 or higher
- Access to database schema files

## Local Machine Requirements
- Python 
- psycopg2 or psycopg2-binary
- postgresql-client
- Configured .pgpass file with 600 permissions
- Access to RDS on port 5432

## Role Structure
```
postgresql-rds/
├── defaults/
│   └── main.yml          # Default variables
├── files/
│   └── schema/           # Database schema files
├── tasks/
│   ├── main.yml                       # Main tasks
│   ├── create_db_from_schema_main.yml # Main DB schema deployment
│   └── create_db_from_schema_cp.yml   # Shard DB schema deployment
└── vars/
    └── main.yml          # Internal variables
```

## Role Variables

### Required Variables for box.yml

```yaml
shards: [0,1,2,3,4,5,6,7,8,9]
shards_numbers: [0,1,2,3,4,5,6,7,8,9]
shards_count: "{{ shards_numbers|length }}"
real_db_numbers: [0,1,2,3,4,5,6,7,8,9]

db_superuser_login: "postgres"
db_superuser_password: "{{ db_superuser_password_enc }}"

db_main:
   host: "127.0.0.1"
   port: "{{ db_port }}"
   user: "internal_user"
   pass: "{{ db_app_user_pass_enc }}"

db_app_user: "{{ db_main.user }}"
db_fdw_user: "fdw_user"

db_shards_rds:
   host: "{{ db_main.host }}"
```

### Required Variables for box-credential.yml example

```yaml
db_superuser_password_enc: "asho7Yutoopheek7"
db_app_user_pass: "okuiNgie5Gohnie3p"
db_app_user_pass_enc: "okuiNgie5Gohnie3p"
db_monitoring_user_password: "kuiNgie5Gohnie3p"
db_fdw_user_pass: "oot8boY6OhXooleo"
db_fdw_user_pass_enc: "oot8boY6OhXooleo"
```

## Tags

### Main Tasks
- `rds-all`: All role tasks
- `rds-create-roles`: Create database roles
- `rds-create-app-user`: Create application users
- `rds-grant-role-to-app-user`: Grant roles to users
- `rds-create-main-dbs`: Create main databases
- `rds-create-shard-dbs`: Create shard databases
- `rds-deploy-main-schema`: Deploy main database schemas
- `rds-deploy-shards-schema`: Deploy shard database schemas

### Schema Deployment
- `pgsql-all`: All schema deployment tasks
- `pgsql-deploy-schema`: Schema deployment tasks
- `pgsql-alter-table-conveyor_fdw`: FDW table alterations

## Usage Examples

### file hosts
```yaml
[rds]
localhost ansible_connection=local
```
### Basic Installation
```yaml
 - hosts: rds
   become: true
   vars_files:
     - vars/box.yml
     - vars/box-credentials.yml
   roles:
     - postgresql-rds
```

### Main Databases
- conveyor
- cce
- health_check
- conveyor_statistics
- settings
- limits
- git_call
- accounts

### Shard Databases
- cp[number] (e.g., cp1, cp2, cp3)

## Security Features

- Encrypted password storage
- Role-based access control
- Secure schema permissions
- Temporary file cleanup
- Limited user privileges

## Troubleshooting

### Common Issues

1. Schema Deployment Failures:
    - Check schema file existence
    - Verify database connections
    - Check user permissions

2. User Creation Issues:
    - Verify password hashing
    - Check role existence
    - Confirm superuser privileges

3. Permission Problems:
    - Review role assignments
    - Check schema ownership
    - Verify FDW configurations

## Author Information

Created and maintained by Middleware

## Support

For issues:
1. Check the troubleshooting section
2. Review logs and error messages
3. Contact database administration team
