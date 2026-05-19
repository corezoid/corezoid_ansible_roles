# Ansible Role: atop

Installs and configures the `atop` system monitor. Writes binary performance logs to disk at a configurable interval, rotates them daily, and prunes/compresses old files.

## Log lifecycle

Responsibility is split between two mechanisms:

- **`atop-rotate.timer`** (shipped with the atop package): restarts the daemon at 00:00 daily, which causes atop to open a new `atop_YYYYMMDD` file. This is the actual *rotation*.
- **`/etc/logrotate.d/atop`** (deployed by this role): runs daily via `logrotate.timer`/`cron.daily`, compresses prior `atop_*` files with gzip, and deletes any older than `atop_log_generations` days. The packaged `atop-rotate.service` does **not** clean up old files on its own — `LOGGENERATIONS` from `/etc/sysconfig/atop` is honoured only via this logrotate config.

## Supported Platforms

- CentOS / RHEL 7, 8, 9
- Amazon Linux 2, 2023

## Requirements

- Ansible 2.13.5 or higher
- Root or sudo privileges on target hosts

---

## Role Variables

Variables are defined in `defaults/main.yml` — the lowest priority, overridable from anywhere.

| Variable | Default | Description |
|---|---|---|
| `atop_interval` | `5` | Sample interval in seconds |
| `atop_log_path` | `/var/log/atop` | Directory for binary log files |
| `atop_log_generations` | `3` | Days of logs to retain (enforced by logrotate) |
| `atop_logo_opts` | `""` | Extra flags passed to the atop daemon |

### Where variables are stored

```
roles/atop/
└── defaults/main.yml   # default values (lowest priority)
```

### How to override

**1. In your inventory host/group vars** (recommended for per-environment tuning):
```
inventories/<env>/group_vars/all.yml
inventories/<env>/host_vars/<hostname>.yml
```
```yaml
atop_interval: 10
atop_log_generations: 14
```

**2. Directly in your playbook**:
```yaml
- hosts: all
  roles:
    - role: atop
      vars:
        atop_interval: 10
        atop_log_generations: 14
```

**3. Via `--extra-vars` at runtime**:
```bash
ansible-playbook site.yml --extra-vars "atop_interval=10 atop_log_generations=14"
```

Variable priority (highest → lowest): `--extra-vars` > playbook vars > host_vars > group_vars > `defaults/main.yml`.

---

## Tags

| Tag | Description |
|---|---|
| `atop-all` | Run all tasks |
| `atop-install` | Install package and create log directory |
| `atop-config` | Deploy sysconfig and logrotate config |
| `atop-service` | Enable and start systemd services |

Run only specific stages:
```bash
ansible-playbook site.yml --tags atop-config
```

---

## Testing

### Prerequisites

```
inventories:  roles/atop/tests/inventory
playbooks:    roles/atop/tests/test.yml
              roles/atop/tests/uninstall.yml
```

Set `ANSIBLE_ROLES_PATH` so Ansible can resolve the role:
```bash
export ANSIBLE_ROLES_PATH=/path/to/coreformation/ansible/roles
```

---

### Install (dry-run)

Preview all changes without applying them:
```bash
ansible-playbook --check --diff \
  -i roles/atop/tests/inventory \
  roles/atop/tests/test.yml
```

> Note: `--check` does not install the package, so service tasks will report errors — this is expected.

### Install (apply)

```bash
ansible-playbook \
  -i roles/atop/tests/inventory \
  roles/atop/tests/test.yml
```

### Install with custom variables

```bash
ansible-playbook \
  -i roles/atop/tests/inventory \
  roles/atop/tests/test.yml \
  --extra-vars "atop_interval=10 atop_log_generations=14"
```

### Install only specific stages

```bash
# Only deploy configs (skip install/service tasks)
ansible-playbook \
  -i roles/atop/tests/inventory \
  roles/atop/tests/test.yml \
  --tags atop-config
```

### Verify on the host after install

```bash
systemctl status atop
systemctl status atop-rotate.timer
cat /etc/sysconfig/atop                       # check LOGINTERVAL=5
cat /etc/logrotate.d/atop                     # check logrotate stanza
ls -la /var/log/atop/                         # check log files are being written
systemctl list-timers atop-rotate.timer       # daily daemon restart
logrotate -d /etc/logrotate.d/atop            # dry-run: see what cleanup would do
```

---

### Uninstall

Removes the package, service, configs, and log directory:
```bash
ansible-playbook \
  -i roles/atop/tests/inventory \
  roles/atop/tests/uninstall.yml
```

Verify removal:
```bash
systemctl status atop            # should return: Unit atop.service could not be found
rpm -q atop                      # should return: package atop is not installed
ls /var/log/atop                 # should return: No such file or directory
```
