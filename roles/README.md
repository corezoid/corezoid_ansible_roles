# Corezoid Ansible roles — installing on RHEL 9 family (RHEL / Oracle Linux / Rocky / AlmaLinux 9)

Status 2026-10-08 (branch `os-matrix/el9-roles`). The same RPMs (`<release>/redhat/9`) serve all four
flavours; the roles only differ in how EPEL is enabled. Amazon Linux 2023 and RHEL 8 family work the
same way with `amazon2023/*` and `redhat/8`.

## Play layout

Put `role: yum` **first in every play that installs a Corezoid component**, not only in the
RabbitMQ play. Since this branch every application role asserts that `corezoid-prod.repo` exists and
fails early otherwise (that was the INF-30520 failure mode: `cz-worker` play without `role: yum`).
`yum_s3_bucket_prefix` no longer has to be spelled out — the role derives `redhat/<major>` /
`amazon2023/<arch>` from facts; the explicit form keeps working.

```yaml
- hosts: cz-api
  become: true
  vars_files: [vars/box.yml, vars/box-credentials.yml]
  roles:
    - role: yum
    - role: system
    - role: conf_agent_server
    - role: corezoid_limits
    - role: capi
```

## What changed for EL9 on this branch

| Area | Before | Now |
|---|---|---|
| Corezoid repo path | hardcoded per play (`redhat/7` in the public example) | derived from facts, override allowed |
| EPEL | CentOS/Rocky/Alma only in `yum`; Oracle in `system`; RHEL "out of scope" | all flavours in `yum` (+CRB), Oracle/CentOS/Rocky/Alma also kept in `system` for `system-only.yml` |
| SHA1-signed RPMs vs EL9 crypto policy | manual `update-crypto-policies --set LEGACY` on the host, or the side effect of role `elasticsearch` | explicit preflight in `yum` with a readable failure; documented override `corezoid_allow_sha1_policy: true`; `elasticsearch` SHA1 task opt-in |
| Rocky / AlmaLinux | `monit`/`redis`/`rabbitmq` RPM lookups failed (undefined key); PostgreSQL/pgbouncer/SELinux tasks skipped silently | RHEL-family conditions (`ansible_os_family == 'RedHat' and ansible_distribution != 'Amazon'`); lookups keyed on `RedHat-<major>-<arch>` |
| usercode `libcrypto.so.1.0.0` | always copied on OracleLinux 8 | `usercode_install_legacy_libcrypto` (default = old behaviour) |

## Known limitations

- `postgresql`: pglogical / pg_repack bundled RPMs are installed only on Amazon Linux 2023
  (`roles/postgresql/files/`); on EL9 install them from PGDG by hand if the primary uses them.
- `postgresql` EL7/EL8 use the PGDG `EL-7` repo rpm as before (untouched).
- `rp` uses `nginx.org/packages/centos/<major>` — correct for EL8/EL9, not for Amazon Linux.
- ansible-core 2.15 is required (legacy `include:` in `postgresql`, multi-line `debug: var:` in `system`).
- Debian/Ubuntu: only infrastructure roles have apt paths; application roles are yum-only and there is
  no .deb repository (prototype in `corezoid_build_all`, branch `os-matrix/ubuntu-deb`).

## Public example repository

`github.com/corezoid/corezoid_ansible_roles` mirrors only `roles/`; its root `cz-init.yml` / `hosts` /
`README.md` are maintained on GitHub and still show `role: yum` commented out with `redhat/7` — update
them when this branch is merged.
