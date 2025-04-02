# CAPI Role

This Ansible role installs and configures the `capi` service for the Corezoid platform.

## Overview

The role performs the following main functions:
- Installs the CAPI package from the AWS Corezoid repository
- Creates necessary directories with appropriate permissions
- Sets up static content directories for avatars
- Configures the application with a secure configuration file
- Configures Monit for service monitoring
- Ensures service starts automatically and survives reboots

## Requirements

- RHEL/CentOS 7/8/9 or Amazon Linux 2/2023
- Access to the AWS Corezoid repository
- Monit should be installed on the target system

## Role Variables

### Required Variables for box.yml

```yaml
top_dir: "/ebsmnt"
conf_dir: "{{ top_dir }}/conf"
app_user: "app-user"

corezoid_release: 6.7.3

corezoid_release_app_version:
  capi: "8.4.1.3"

capi:
  version: "{{ corezoid_release_app_version.capi }}"
  config: "{{ conf_dir }}/capi.config"

capi_endpoint: "ae-8928.middleware.biz"
capi_cookie_name: "ae-8928.middleware.biz"
capi_main_domain: "{{ capi_endpoint }}"

capi_admin_url1: "{{ capi_endpoint }}"
capi_admin_url2: "{{ capi_admin_url1 }}"

superadmin_endpoint: "superadmin-ae-7682.middleware.biz"

capi_email_confirm: "false"
companies_manager: corezoid_internal
capi_check_api_info_group: 1

capi_front_sender_editor_domain: "builder-dev.ae-7682.middleware.biz"
capi_front_sender_editor: "https://{{ capi_front_sender_editor_domain }}/embed.js?"

capi_auth_single_account: "false" # if only corezoid

capi_timer_min: 1

capi_super_admin_id: 1
capi_api_max_threads: 200
capi_user_limits_max_interface_rate: 120
capi_user_limits_max_user_rate: 2000
capi_check_info_group_id: 6
capi_service_desk_group_id: 83303
capi_hosts:
  - { host: "10.70.0.171" }
  - { host: "10.70.0.172" }

capi_max_task_size_for_process_conv: "{{ worker_max_task_size }}"
capi_max_task_size_for_st_diagramm_conv: "{{ worker_max_task_size_for_st_diagramm_conv }}"

capi_api_secret: "{{ capi_api_secret_enc }}"
capi_auth_hash: "{{ capi_auth_hash_enc }}"

capi_sender: "on"
capi_sender_build_form_url: "https://api-conv-dev.ae-7682.middleware.biz"
capi_sender_build_action_url: "https://api-adm-dev.ae-7682.middleware.biz"
capi_sender_call_action_url: "{{ capi_sender_build_form_url }}"
capi_sender_secret: "{{ capi_sender_secret_enc }}"
capi_sender_plugin_secret: "{{ capi_sender_plugin_secret }}"
capi_sender_max_threads: 25
capi_sender_env: "md"
sender_ui: false

capi_elasticsearch: true
capi_copilot_sdk_enable: false
capi_copilot_sdk:
  api_key: ""
  path_completion: ""
  path_explanation: ""

capi_oauth_pb: "false"
capi_auth_ldap: "false"
capi_auth_google: "false"
capi_corezoid_auth: "true"
capi_box_solution: "false"
send_invite: "true"

capi_ldap_host: "127.0.0.1"
capi_ldap_port: "389"
capi_ldap_tls: "false"
capi_ldap_base: "o=my"
capi_ldap_filter: "uid"
capi_ldap_first_bind_user: "true"
capi_ldap_bind_user_name_name: ""
capi_ldap_bind_user_name: "{{ capi_ldap_filter }}={{ capi_ldap_bind_user_name_name }},{{ capi_ldap_base }}"
capi_ldap_bind_user_pass: "123"
capi_ldap_user_nick_entry: ""

capi_oauth_pb_client_id: ""
capi_oauth_pb_client_secure: ""

capi_oauth_pb_return_url: ""
capi_oauth_pb_oauth_url: ""
capi_oauth_pb_token_url: ""
capi_oauth_pb_userinfo_url: ""
capi_oauth_pb_logout_url: ""
capi_oauth_pb_isauthorize_url: ""
###### Dbcall configure #####
db_call: false
db_callv2: false
## db_call_url without endslash !!!
db_call_url: "https://corezoid.loc"
db_call_vhost: "/conveyor"
db_call_host_rmq: 127.0.0.1
###### Dbcall configure end #####
###### Gitcall configure #####
git_call: false
git_call_vhost: "/conveyor"
git_call_dunder_vhost: "/conveyor"
git_call_dbname: "git_call"
###### Gitcall configure end #####


capi_front_settings:
  ui:
    - { market: "false", company: "true", bot_platform: "false", old_editor: "false", search: "true", billing: "false", default_company: "My Corezoid", disabled_auth_logo: "false", git_call: "false" }

capi_front_captcha_key: ""
capi_front_captcha_key_disabled: "true"
capi_backend_settings_cpatcha_key: ""
capi_backend_settings_cpatcha_disabled: "true"

capi_telegram: true
capi_telegram_url: "https://api.telegram.org/bot"
capi_telegram_conv: 1331

capi_validate_scheme_links: "false"

capi_conv_logs: 84461

capi_redis2_start_size: 10
capi_redis2_min_size: 10
capi_redis2_max_size: 100

```

## Templates

The role requires the following templates:
- `templates/[corezoid_release]-capi.config.j2` - Main application configuration
- `templates/capi.monit.j2` - Monit monitoring configuration

## Example Playbook

```yaml
- hosts: cz_capi
  become: true
  vars_files:
    - vars/box.yml
    - vars/box-credentials.yml
  roles:
    - role: capi
```

## Role Structure

```
capi/
├── defaults/
│   └── main.yml          # Default variables   
├── handlers/
│   └── main.yml          # Event handlers
├── meta/
│   └── main.yml          # Role metadata
├── tasks/
│   └── main.yml          # Main tasks
├── templates/
│   ├── *-capi.config.j2    # Configuration templates
│   └── capi.monit.j2       # Monit configuration template
├── files/
│   └── default_avatar.jpg  # Default avatar image
└── vars/
    └── main.yml          # Internal variables
```

## Tags

You can use the following tags to run specific parts of the role:

- `capi-all` - Run all tasks
- `capi-app` - All application-related tasks
- `capi-install` - Just install the package
- `capi-config` - Update configuration files
- `capi-config-file` - Update only the main config file
- `capi-start` - Start the service
- `capi-monit` - Update Monit configuration

Example:
```
ansible-playbook -i inventory playbook.yml --tags "capi-config"
```

## Author

Created and maintained by Middleware