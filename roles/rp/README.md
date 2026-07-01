# rp — reverse proxy / NGINX role

Reusable Ansible role that installs the latest stable **NGINX** (from the
official `nginx.org` repo) and renders best-practice, per-client / per-environment
configuration entirely from Jinja2 templates. Custom locations are described as
**data** and rendered through reusable Jinja2 macros — no hand-written nginx
blocks needed per client.

## What it does

- Adds the official `nginx.org` repository (stable by default) and installs the
  newest NGINX — far ahead of the distro-bundled package. Pin an exact version
  with `rp_nginx_version` for reproducible builds.
- Deploys a hardened `nginx.conf` (worker tuning, `server_tokens off`, gzip,
  rate-limit zones, real-IP behind LB, websocket upgrade map, log formats).
- Ships reusable snippets in `/etc/nginx/snippets/`:
  `ssl.conf` (Mozilla-intermediate TLS), `security.conf` (HSTS + security
  headers), `proxy.conf` (forwarded headers).
- Renders one vhost per entry in `rp_sites`, with locations built by the
  `render_location` macro.
- Optional catch-all default server returning `444` for unmatched Host headers.
- **Always runs `nginx -t` before any reload** — a bad template fails the play
  instead of taking the service down.

## Platforms

Enterprise Linux 7/8/9, Amazon Linux 2 / 2023 (yum/dnf).
On Amazon Linux set `rp_nginx_repo_releasever` (e.g. `"9"` for AL2023, `"7"`
for AL2) since `nginx.org` publishes per CentOS releasever.

## Usage

Add to a play and drive everything from inventory `group_vars` / `host_vars`:

```yaml
- hosts: rp
  become: true
  roles:
    - rp
```

### Tags

`rp-all`, `rp-install`, `rp-repo`, `rp-config`, `rp-mainconfig`, `rp-snippets`,
`rp-upstreams`, `rp-vhosts`, `rp-validate`, `rp-service`.

## Per-client / per-environment configuration

Put the differences in `inventories/<client-env>/group_vars/rp.yml`. Example:

```yaml
# Amazon Linux 2023
rp_nginx_repo_releasever: "9"

rp_upstreams:
  - name: app_backend
    keepalive: 32
    servers:
      - "10.0.0.10:8080"
      - { address: "10.0.0.11:8080", params: "weight=2 max_fails=3 fail_timeout=15s" }

rp_sites:
  - name: api.client.com
    server_name: api.client.com
    ssl:
      enabled: true
      certificate: /etc/nginx/ssl/api.client.com.crt
      certificate_key: /etc/nginx/ssl/api.client.com.key
    redirect_http: true          # 80 -> 443
    client_max_body_size: "32m"
    locations:
      - path: /
        proxy_pass: http://app_backend
        websocket: true
        limit_req: "zone=perip burst=50 nodelay"
      - path: /static/
        match: "^~"
        root: /var/www
        add_headers:
          - { name: Cache-Control, value: "public, max-age=86400" }
      - path: /healthz
        return: "200 'ok'"
        access_log: "off"
      - path: /admin
        match: "^~"
        proxy_pass: http://app_backend
        proxy_set_header:
          - { name: X-Internal, value: "1" }
        extra: |
          allow 10.0.0.0/8;
          deny all;
```

### Site schema (`rp_sites[*]`)

| key | meaning |
|-----|---------|
| `name` (required) | conf filename + per-site error log name |
| `server_name` (required) | hostname(s), space-separated |
| `listen` | HTTP port (default 80) |
| `ssl.enabled` | enable TLS server |
| `ssl.listen` | TLS port (default 443) |
| `ssl.certificate` / `ssl.certificate_key` | cert paths |
| `ssl.http2` | enable HTTP/2 (default true) |
| `ssl.self_signed` | generate a self-signed cert on first run if missing (dev/test) |
| `redirect_http` | add :80 server that 301s to https (default = ssl) |
| `security_headers` | include security snippet (default true on ssl) |
| `client_max_body_size` | per-site body limit |
| `access_log` | per-client access log path + format |
| `error_log` | per-client error log path (default `/var/log/nginx/<name>.error.log`) |
| `extra_server` | raw lines injected into the server block |
| `locations` | list of location dicts (below) |

### Location schema (`locations[*]`) — rendered by `render_location`

| key | meaning |
|-----|---------|
| `path` (required) | location path |
| `match` | operator: `""`, `=`, `~`, `~*`, `^~` |
| `proxy_pass` | upstream/URL to reverse-proxy to |
| `websocket` | inject Upgrade/Connection headers |
| `return` | e.g. `"301 https://$host$request_uri"`, `"444"` |
| `root` / `alias` | static file serving |
| `try_files` / `index` | static routing |
| `client_max_body_size` | per-location body limit |
| `limit_req` / `limit_conn` | reference zones from defaults |
| `access_log` | e.g. `"off"` |
| `add_headers` | `[{name, value[, always]}]` |
| `proxy_set_header` | extra `[{name, value}]` |
| `proxy_read_timeout` / `proxy_connect_timeout` / `proxy_send_timeout` / `proxy_buffering` | proxy tuning |
| `extra` | raw lines injected verbatim (escape hatch) |

## Reusing the macros

Macros live in `templates/_macros.j2`:

- `render_location(loc)` — full `location` block from a dict.
- `proxy_block(loc)` — standard forwarded-header set (+ optional websocket).
- `add_headers(headers)` — emit `add_header` lines from a list.

Import them in any custom template:

```jinja2
{% from "_macros.j2" import render_location, add_headers with context %}
```

## Key variables (see `defaults/main.yml` for all)

- `rp_use_official_repo` / `rp_nginx_repo_channel` / `rp_nginx_repo_releasever`
- `rp_nginx_version` (empty = latest)
- Tuning: `rp_worker_*`, `rp_keepalive_*`, `rp_client_max_body_size`, gzip vars
- TLS: `rp_ssl_protocols`, `rp_ssl_ciphers`, `rp_hsts_header`, `rp_security_headers`
- `rp_limit_req_zones` / `rp_limit_conn_zones`
- `rp_set_real_ip_from`
- `rp_upstreams`, `rp_sites`, `rp_default_server_drop`
- Log rotation: `rp_logrotate_enabled`, `rp_logrotate_frequency`, `rp_logrotate_rotate`, `rp_logrotate_compress`, `rp_logrotate_delaycompress` (default policy: keep 5 days, archive the older 4 rotated files, delete the rest — deploys `/etc/logrotate.d/nginx`)
