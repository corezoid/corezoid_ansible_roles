# Ansible Role: Redis

Ansible role for installing and configuring Redis.

## Supported Platforms

- CentOS 7, 8, 9
- Red Hat Enterprise Linux 7, 8, 9
- Oracle Linux 7, 8, 9
- Amazon Linux 2023 (x86_64, aarch64)
- Amazon Linux 2

## Requirements

- Ansible 2.13.5 or higher
- Root privileges on target servers
- Monit installed (for monitoring)
- Access to Redis RPM packages

## Role Variables

### Required Variables for box.yml 

```yaml
redis_version: "7.2.4"

redis_counters_host: "127.0.0.1"
redis_counter_name: "redis-counters"
redis_counter_port: 6379
redis_counters_db: 0
redis_api_sum_db: 1
redis_users_db: 12
redis_counter_dir: "{{ top_dir }}/{{ redis_counter_name }}"
redis_counter_conf: "/etc/{{ redis_counter_name }}.conf"
redis_install_counter: true

redis_cache_host: "{{ redis_counters_host }}"
redis_cache_name: "redis-cache"
redis_cache_port: 6380
redis_cache_db: 2
redis_cache_dir: "{{ top_dir }}/{{ redis_cache_name }}"
redis_cache_conf: "/etc/{{ redis_cache_name }}.conf"
redis_install_cache: true

redis_timers_host: "{{ redis_cache_host }}"
redis_timers_name: "redis-timers"
redis_timers_port: 6381
redis_timers_db: 3
redis_timers_dir: "{{ top_dir }}/{{ redis_timers_name }}"
redis_timers_conf: "/etc/{{ redis_timers_name }}.conf"
redis_install_timers: true

redis_api_sum:
   - { host: "{{ redis_counters_host }}", port: "{{ redis_counter_port }}", password: "", db: "{{ redis_api_sum_db }}" }

redis_users:
   - { host: "{{ redis_counters_host }}", port: "{{ redis_counter_port }}", password: "", db: "{{ redis_users_db }}" }

redis_cache:
   - { host: "{{ redis_cache_host }}", port: "{{ redis_cache_port }}", password: "", db: "{{ redis_cache_db }}" }

redis_timers:
   - { host: "{{ redis_timers_host }}", port: "{{ redis_timers_port }}", password: "", db: "{{ redis_timers_db }}" }
```

## Tags

- `redis-all`: All role tasks
- `redis-install`: Package installation only
- `redis-create-dirs`: Directory creation
- `redis-create-configs`: Configuration deployment
- `redis-create-pid-file`: PID file management
- `redis-start-enable`: Service management
- `redis-monit`: Monitoring setup

## Dependencies
- system roles (for Monit configuration))

## Usage Examples

### Basic Installation

```yaml
 - hosts: cz_all
   become: true
   vars_files:
      - vars/box.yml
      - vars/box-credentials.yml
   roles:
      - { role: redis, redis_version: "7.2.4"}
```

### Only Installation Cache Server 

```yaml
 - hosts: cz_all
   become: true
   vars_files:
      - vars/box.yml
      - vars/box-credentials.yml
   roles:
      - { role: redis, redis_version: "7.2.4", redis_install_counter: false, redis_install_cache: true, redis_install_timers: false }
```

## Role Structure

```
redis/
├── defaults/
│   └── main.yml          # Default variables
├── files/
│   └── redis-*.rpm       # RPM packages
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── redis-box-*.conf.j2    # Configuration templates
│   ├── redis-service.j2       # Systemd service template
│   ├── limits.conf.j2         # Resource limits template
│   └── redis.monit.j2         # Monit configuration template
└── vars/
    └── main.yml          # Internal variables
```

## Monitoring

The role configures Monit monitoring with the following checks:

- Redis process monitoring
- Memory usage monitoring
- Port availability check
- CPU usage monitoring
- Dump file size monitoring

## Security

- All configuration files have 0644 permissions
- Directories have 0755 permissions
- Files are owned by redis user
- Monit configuration has 0600 permissions

## Troubleshooting

### Common Issues

1. Service won't start:
    - Check system logs: `journalctl -u redis-*`
    - Verify directory permissions
    - Ensure ports are available

2. Package installation errors:
    - Check RPM presence in files/ directory
    - Verify architecture compatibility
    - Check package dependencies

3. Monit issues:
    - Check status: `monit status`
    - View logs: `tail -f /var/log/monit.log`

## License

MIT

## Author

Created by [Author Name]  
Maintained by [Company Name]

## Support

If you encounter issues:

1. Check the "Troubleshooting" section
2. Review open and closed issues
3. Create a new issue with a detailed problem description