# Ansible Role: YUM Repository Management

Configures the Corezoid package repository (`aws-corezoid`) and EPEL on RPM-based hosts.
**Every play that installs a Corezoid application role (capi, worker, usercode, http-worker,
sync-api, api-multipart, conf_agent_server, corezoid_limits, front_capi) must run this role
first** — the application roles now assert that `/etc/yum.repos.d/corezoid-prod.repo` exists
and stop with a readable message if it does not (INF-30520).

## Supported Platforms

- RHEL 7, 8, 9
- CentOS 7, CentOS Stream 8/9
- Oracle Linux 7, 8, 9
- Rocky Linux 8, 9 and AlmaLinux 8, 9 (same `redhat/<major>` packages as RHEL)
- Amazon Linux 2 and 2023 (x86_64 and arm64)
- Debian/Ubuntu: apt cache preflight only — there is no Corezoid .deb repository yet

## Requirements

- Ansible 2.13.5 – 2.15.x (the repository's roles are not yet ported to ansible-core ≥ 2.16)
- Outbound HTTPS to `repo.middleware.biz` (and `dl.fedoraproject.org` on RHEL for EPEL)
- Root access

## Role Variables (defaults/main.yml)

```yaml
yum_s3_bucket: "corezoid"
# yum_s3_bucket_prefix is derived from facts when not set:
#   RHEL/CentOS/OracleLinux/Rocky/AlmaLinux -> "{{ corezoid_release }}/redhat/{{ major }}"
#   Amazon Linux 2    -> "{{ corezoid_release }}/amazon2/{latest|arm64}"
#   Amazon Linux 2023 -> "{{ corezoid_release }}/amazon2023/{latest|arm64}"
# yum_s3_bucket_prefix: "{{ corezoid_release }}/redhat/9"   # explicit override still works

yum_enable_epel: true            # EPEL (+CRB) per flavour: epel-release, oracle-epel-release-elN,
                                 # fedoraproject rpm + subscription-manager CRB on RHEL
yum_rhel_crb_fail_fatal: false   # RHEL: CRB enable failure (no subscription) is reported, not fatal

corezoid_repo_preflight: true                  # EL9+: check repo signature vs crypto policy
corezoid_repo_preflight_package: conf-agent-client
corezoid_allow_sha1_policy: false              # EMERGENCY override, see below
```

`corezoid_repo_domain` (set by some inventories to a private mirror) still switches the repo to
`gpgcheck=0` as before; the preflight is skipped in that case.

## EL9 and SHA1-signed packages

RHEL 9 / Oracle Linux 9 / Rocky 9 / AlmaLinux 9 with the `DEFAULT` or `FUTURE` crypto policy refuse
RPMs signed with RSA/SHA1. Corezoid repositories published before the SHA256 re-signing
(`corezoid_build_all/rpm-sign`, branch `os-matrix/sign-sha256`) are SHA1-signed, so `dnf` fails with:

```
warning: Signature not supported. Hash algorithm SHA1 not available.
Problem opening package conf-agent-client-2.6.3-1.el9.x86_64.rpm
Error: GPG check FAILED
```

Instead of letting that happen inside an application role, this role downloads one small package
from `aws-corezoid`, reads the signature digest from its header and:

- **SHA256-signed repository** → nothing to do.
- **SHA1-signed repository + policy DEFAULT/FUTURE** → the play **fails here** with the message above
  and the fix options.
- `corezoid_allow_sha1_policy: true` → applies `update-crypto-policies --set DEFAULT:SHA1`
  host-wide and prints a warning. This is an audited, temporary override for one install; revert
  with `update-crypto-policies --set DEFAULT` once the repository is re-signed.

The previous implicit workaround (role `elasticsearch` setting `DEFAULT:SHA1` on EL9) is now
opt-in (`elasticsearch_set_sha1_policy`).

## Example play (EL9 host, prefix derived automatically)

```yaml
- hosts: cz-api
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: yum                 # redhat/9 is derived from facts
    - role: system
    - role: conf_agent_server
    - role: corezoid_limits
    - role: capi
```

Explicit form (unchanged, still supported):

```yaml
    - { role: yum, yum_s3_bucket: "corezoid", yum_s3_bucket_prefix: "{{ corezoid_release }}/redhat/9" }
```

## Tags

- `yum-all`: all tasks
- `yum-debug` / `getdist`: system information only
- `yum-epel-repo-install`: EPEL / CRB only
- `yum-corezoid-repo`: Corezoid repo file, GPG key and the EL9 preflight
- `yum-preflight`: the EL9 signature preflight only
- `yum-debian-preflight`: Debian/Ubuntu apt preflight

## Author

Created and maintained by Middleware Inc.
