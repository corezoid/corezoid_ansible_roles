
CREATE EXTENSION IF NOT EXISTS pg_repack WITH SCHEMA public;

COMMENT ON EXTENSION pg_repack IS 'Reorganize tables in PostgreSQL databases with minimal locks';

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'history_v2_level') THEN
        CREATE TYPE history_v2_level AS ENUM (
            'OK',
            'ERROR'
        );
        END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'history_v2_rows_severity') THEN
        CREATE TYPE history_v2_rows_severity AS ENUM (
            'INFO',
            'WARN',
            'ERROR'
        );
        END IF;
END
$$;

CREATE TABLE IF NOT EXISTS api_callbacks (
    conveyor_id integer NOT NULL,
    hash character(40) NOT NULL,
    data text
);

CREATE TABLE IF NOT EXISTS cce_exec_time (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    sum_time real NOT NULL,
    sum_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);

CREATE TABLE IF NOT EXISTS channel_storage (
    conveyor_id integer NOT NULL,
    channel character varying(100) NOT NULL,
    data text
);

CREATE TABLE IF NOT EXISTS companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    owner_user_id integer NOT NULL,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    server_id integer,
    company_id character varying(25) NOT NULL,
    status smallint DEFAULT 1
);

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;

CREATE TABLE IF NOT EXISTS conveyor_billing (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    ts integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size bigint NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);

CREATE SEQUENCE conveyor_billing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE conveyor_billing_id_seq OWNED BY conveyor_billing.id;

CREATE TABLE IF NOT EXISTS conveyor_called_timers (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    called_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);

CREATE TABLE IF NOT EXISTS conveyor_id_to_conveyor_ref (
    conveyor_ref character varying(255) NOT NULL,
    env character varying(10) NOT NULL,
    conveyor_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS conveyor_to_shard (
    conveyor_id integer NOT NULL,
    shard character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS conveyors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    status smallint DEFAULT 1,
    params text,
    owner_id integer,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    esc_conv integer,
    conv_type smallint,
    company_id character varying(25),
    blocked_reason character varying(2000) DEFAULT NULL::character varying,
    project_id integer,
    version integer DEFAULT 1 NOT NULL
);

CREATE SEQUENCE conveyors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE conveyors_id_seq OWNED BY conveyors.id;

CREATE TABLE IF NOT EXISTS dashboards (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_id integer NOT NULL,
    data text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25),
    charts_order text,
    timerange text,
    grid text,
    project_id integer
);

CREATE SEQUENCE dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE dashboards_id_seq OWNED BY dashboards.id;

CREATE TABLE IF NOT EXISTS esc_conv_to_convs (
    esc_conv integer NOT NULL,
    conv integer NOT NULL
);

CREATE SEQUENCE external_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS external_services (
    id integer DEFAULT nextval('external_services_id_seq'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    type smallint DEFAULT 0,
    status smallint DEFAULT 1,
    company_id character varying(25),
    project_id integer,
    hash character varying(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS folder_content (
    folder_id integer NOT NULL,
    obj_type integer NOT NULL,
    obj_id integer NOT NULL,
    id bigint NOT NULL
);

CREATE SEQUENCE folder_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE folder_content_id_seq OWNED BY folder_content.id;

CREATE TABLE IF NOT EXISTS folders (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_id integer NOT NULL,
    type smallint DEFAULT 0,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25),
    project_id integer
);

CREATE SEQUENCE folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE folders_id_seq OWNED BY folders.id;

CREATE TABLE IF NOT EXISTS group_to_group (
    parent_group_id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS history (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL,
    change_time integer NOT NULL,
    title text,
    action_type smallint,
    id bigint NOT NULL
);

CREATE SEQUENCE history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE history_id_seq OWNED BY history.id;

CREATE TABLE IF NOT EXISTS history_v2 (
    id integer NOT NULL,
    create_time integer NOT NULL,
    level history_v2_level DEFAULT 'OK'::history_v2_level,
    path text,
    vsn integer,
    user_id integer,
    service character varying(50),
    ip character varying(39),
    request text NOT NULL,
    response text NOT NULL
);

CREATE SEQUENCE history_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE history_v2_id_seq OWNED BY history_v2.id;

CREATE TABLE IF NOT EXISTS history_v2_rows (
    id integer NOT NULL,
    history_id integer,
    severity history_v2_rows_severity DEFAULT 'INFO'::history_v2_rows_severity,
    company_id character varying(50) DEFAULT NULL::character varying,
    project_id integer,
    type character varying(50) NOT NULL,
    obj character varying(50) NOT NULL,
    obj_type character varying(50) DEFAULT NULL::character varying,
    obj_id integer,
    obj_to character varying(50) DEFAULT NULL::character varying,
    obj_to_id integer,
    request text NOT NULL,
    response text NOT NULL
);

CREATE SEQUENCE history_v2_rows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE history_v2_rows_id_seq OWNED BY history_v2_rows.id;

CREATE TABLE IF NOT EXISTS login_to_users (
    user_id integer NOT NULL,
    login_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS logins (
    id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    login character varying(100) NOT NULL,
    type smallint NOT NULL,
    hash1 character varying(255),
    hash2 character varying(255)
);

CREATE SEQUENCE logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE logins_id_seq OWNED BY logins.id;

CREATE TABLE IF NOT EXISTS market_template (
    id integer NOT NULL,
    version character varying(20),
    title character varying(255) NOT NULL,
    description text,
    image character varying(500),
    repository_url character varying(500) NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    category_id smallint,
    change_time integer,
    conveyor_params text,
    owner_id integer NOT NULL,
    last_editor_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS market_template_history (
    id integer NOT NULL,
    market_template_id integer NOT NULL,
    description text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    last_editor_id integer
);

CREATE SEQUENCE market_template_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE market_template_history_id_seq OWNED BY market_template_history.id;

CREATE SEQUENCE market_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE market_template_id_seq OWNED BY market_template.id;

CREATE TABLE IF NOT EXISTS oauth2_access (
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    scope text
);

CREATE TABLE IF NOT EXISTS oauth2_client_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    privs text,
    description text,
    status integer DEFAULT 0
);

CREATE SEQUENCE oauth2_client_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE oauth2_client_groups_id_seq OWNED BY oauth2_client_groups.id;

CREATE TABLE IF NOT EXISTS oauth2_clients (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    logo character varying(1024),
    homepage character varying(1024),
    client_id character varying(255) NOT NULL,
    client_secret character varying(255) NOT NULL,
    redirect_uri character varying(1024) NOT NULL,
    notify_url character varying(1024),
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    full_name character varying(255),
    scope text
);

CREATE SEQUENCE oauth2_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE oauth2_clients_id_seq OWNED BY oauth2_clients.id;

CREATE TABLE IF NOT EXISTS oauth2_clients_to_groups (
    id integer NOT NULL,
    client_id integer NOT NULL,
    group_id integer NOT NULL
);

CREATE SEQUENCE oauth2_clients_to_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE oauth2_clients_to_groups_id_seq OWNED BY oauth2_clients_to_groups.id;

CREATE TABLE IF NOT EXISTS oauth2_history (
    id integer NOT NULL,
    client_id integer NOT NULL,
    event_type character varying(255) NOT NULL,
    data text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);

CREATE SEQUENCE oauth2_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE oauth2_history_id_seq OWNED BY oauth2_history.id;

CREATE TABLE IF NOT EXISTS oauth2_scopes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    client_id integer
);

CREATE SEQUENCE oauth2_scopes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE oauth2_scopes_id_seq OWNED BY oauth2_scopes.id;

CREATE TABLE public.oauth2_tokens (
    refresh_token character varying(255) NOT NULL,
    access_token character varying(255) NOT NULL,
    refresh_token_create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    access_token_create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    scope text,
    type smallint DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS single_account_api_keys (
      id serial PRIMARY KEY,
      client_id varchar(255) NOT NULL,
      scope text,
      api_user_id integer NOT NULL,
      api_login text NOT NULL,
      api_login_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS payment_history (
    id integer NOT NULL,
    order_id character(24),
    user_id integer,
    "time" integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    card character(4),
    amount smallint,
    plan_id smallint
);

CREATE SEQUENCE payment_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE payment_history_id_seq OWNED BY payment_history.id;

CREATE TABLE IF NOT EXISTS payment_plans (
    id integer NOT NULL,
    title character(24),
    stripe_plan_id character(24),
    amount integer,
    tps integer,
    tacts bigint,
    currency character(3),
    "interval" character(10)
);

CREATE SEQUENCE payment_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE payment_plans_id_seq OWNED BY payment_plans.id;

CREATE SEQUENCE payments_history_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS payments_history (
    order_id character varying(255) NOT NULL,
    payplan_id integer NOT NULL,
    paytype smallint DEFAULT 0,
    date_start character varying(255) DEFAULT date_part('epoch'::text, now()),
    amount integer NOT NULL,
    tacts integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    state smallint DEFAULT 1,
    payment_id character varying(255),
    id_pk integer DEFAULT nextval('payments_history_id_pk_seq'::regclass) NOT NULL
);

CREATE TABLE IF NOT EXISTS project_envs (
    id integer NOT NULL,
    project_id integer NOT NULL,
    type smallint DEFAULT 1,
    status smallint DEFAULT 1,
    folder_id integer,
    vsn_major smallint DEFAULT 0,
    vsn_minor smallint DEFAULT 0,
    vsn_patch smallint DEFAULT 0,
    active boolean DEFAULT false
);

CREATE SEQUENCE project_envs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE project_envs_id_seq OWNED BY project_envs.id;

CREATE TABLE IF NOT EXISTS projects (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(1024),
    create_time integer NOT NULL,
    change_time integer NOT NULL,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    status smallint NOT NULL,
    company_id character varying(25) NOT NULL
);

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;

CREATE TABLE IF NOT EXISTS starred_objects (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS subscriptions (
    id integer NOT NULL,
    order_id character(24),
    plan_id integer,
    user_id integer,
    status smallint,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    cancel_time integer,
    customer_id text,
    subscription_id text
);

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;

CREATE SEQUENCE user_billing_stats_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS user_billing_stats (
    user_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    conveyor_tacts bigint,
    "timestamp" integer,
    "interval" integer,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('user_billing_stats_id_pk_seq'::regclass) NOT NULL
);

CREATE SEQUENCE user_billing_tacts_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE IF NOT EXISTS user_billing_tacts (
    user_id integer NOT NULL,
    tacts bigint NOT NULL,
    "timestamp" integer NOT NULL,
    "interval" integer NOT NULL,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('user_billing_tacts_id_pk_seq'::regclass) NOT NULL
);

CREATE TABLE IF NOT EXISTS user_dashboards (
    dashboard_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);

CREATE TABLE IF NOT EXISTS user_folders (
    folder_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);

CREATE TABLE IF NOT EXISTS user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24),
    prioritet smallint,
    privs text
);

CREATE SEQUENCE user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;

CREATE TABLE IF NOT EXISTS user_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    status smallint DEFAULT 1,
    company_id character varying(25),
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_user_id integer
);

CREATE SEQUENCE user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;

CREATE TABLE IF NOT EXISTS user_projects (
    project_id integer NOT NULL,
    group_id integer NOT NULL,
    privs text
);

CREATE TABLE IF NOT EXISTS user_roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer
);

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;

CREATE TABLE IF NOT EXISTS user_to_companies (
    id integer NOT NULL,
    company_id character varying(25) NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL
);

CREATE SEQUENCE user_to_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_to_companies_id_seq OWNED BY user_to_companies.id;

CREATE TABLE IF NOT EXISTS user_to_payment_plan (
    id integer NOT NULL,
    user_id integer,
    status smallint,
    card character(4),
    expire_date integer,
    plan_id integer
);

CREATE SEQUENCE user_to_payment_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_to_payment_plan_id_seq OWNED BY user_to_payment_plan.id;

CREATE TABLE IF NOT EXISTS user_to_user_groups (
    user_group_id integer NOT NULL,
    user_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    status boolean DEFAULT true NOT NULL,
    data text,
    last_entrance integer DEFAULT (date_part('epoch'::text, now()))::integer,
    lang character varying(2)
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;

CREATE TABLE IF NOT EXISTS web_settings (
    key character(50) NOT NULL,
    value text
);


ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);

ALTER TABLE ONLY conveyor_billing ALTER COLUMN id SET DEFAULT nextval('conveyor_billing_id_seq'::regclass);

ALTER TABLE ONLY conveyors ALTER COLUMN id SET DEFAULT nextval('conveyors_id_seq'::regclass);

ALTER TABLE ONLY dashboards ALTER COLUMN id SET DEFAULT nextval('dashboards_id_seq'::regclass);

ALTER TABLE ONLY folder_content ALTER COLUMN id SET DEFAULT nextval('folder_content_id_seq'::regclass);

ALTER TABLE ONLY folders ALTER COLUMN id SET DEFAULT nextval('folders_id_seq'::regclass);

ALTER TABLE ONLY history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);

ALTER TABLE ONLY history_v2 ALTER COLUMN id SET DEFAULT nextval('history_v2_id_seq'::regclass);

ALTER TABLE ONLY history_v2_rows ALTER COLUMN id SET DEFAULT nextval('history_v2_rows_id_seq'::regclass);

ALTER TABLE ONLY logins ALTER COLUMN id SET DEFAULT nextval('logins_id_seq'::regclass);

ALTER TABLE ONLY market_template ALTER COLUMN id SET DEFAULT nextval('market_template_id_seq'::regclass);

ALTER TABLE ONLY market_template_history ALTER COLUMN id SET DEFAULT nextval('market_template_history_id_seq'::regclass);

ALTER TABLE ONLY oauth2_client_groups ALTER COLUMN id SET DEFAULT nextval('oauth2_client_groups_id_seq'::regclass);

ALTER TABLE ONLY oauth2_clients ALTER COLUMN id SET DEFAULT nextval('oauth2_clients_id_seq'::regclass);

ALTER TABLE ONLY oauth2_clients_to_groups ALTER COLUMN id SET DEFAULT nextval('oauth2_clients_to_groups_id_seq'::regclass);

ALTER TABLE ONLY oauth2_history ALTER COLUMN id SET DEFAULT nextval('oauth2_history_id_seq'::regclass);

ALTER TABLE ONLY oauth2_scopes ALTER COLUMN id SET DEFAULT nextval('oauth2_scopes_id_seq'::regclass);

ALTER TABLE ONLY payment_history ALTER COLUMN id SET DEFAULT nextval('payment_history_id_seq'::regclass);

ALTER TABLE ONLY payment_plans ALTER COLUMN id SET DEFAULT nextval('payment_plans_id_seq'::regclass);

ALTER TABLE ONLY project_envs ALTER COLUMN id SET DEFAULT nextval('project_envs_id_seq'::regclass);

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);

ALTER TABLE ONLY user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);

ALTER TABLE ONLY user_to_companies ALTER COLUMN id SET DEFAULT nextval('user_to_companies_id_seq'::regclass);

ALTER TABLE ONLY user_to_payment_plan ALTER COLUMN id SET DEFAULT nextval('user_to_payment_plan_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


ALTER TABLE ONLY api_callbacks
    ADD CONSTRAINT api_callbacks_pkey PRIMARY KEY (conveyor_id);

ALTER TABLE ONLY channel_storage
    ADD CONSTRAINT channel_storage_pkey PRIMARY KEY (conveyor_id, channel);

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);

ALTER TABLE ONLY conveyor_id_to_conveyor_ref
    ADD CONSTRAINT conveyor_id_to_conveyor_ref_pkey PRIMARY KEY (conveyor_ref, env);

ALTER TABLE ONLY conveyor_to_shard
    ADD CONSTRAINT conveyor_to_shard_pkey PRIMARY KEY (conveyor_id);

ALTER TABLE ONLY conveyors
    ADD CONSTRAINT conveyors_pkey PRIMARY KEY (id);

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);

ALTER TABLE ONLY esc_conv_to_convs
    ADD CONSTRAINT esc_conv_to_convs_pkey PRIMARY KEY (esc_conv, conv);

ALTER TABLE ONLY external_services
    ADD CONSTRAINT external_services_pkey PRIMARY KEY (id);

ALTER TABLE ONLY folder_content
    ADD CONSTRAINT folder_content_pkey PRIMARY KEY (id);

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);

ALTER TABLE ONLY group_to_group
    ADD CONSTRAINT group_to_group_pkey PRIMARY KEY (parent_group_id, group_id, conveyor_id);

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY history_v2
    ADD CONSTRAINT history_v2_pkey PRIMARY KEY (id);

ALTER TABLE ONLY history_v2_rows
    ADD CONSTRAINT history_v2_rows_pkey PRIMARY KEY (id);

ALTER TABLE ONLY login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);

ALTER TABLE ONLY logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);

ALTER TABLE ONLY market_template_history
    ADD CONSTRAINT market_template_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY market_template
    ADD CONSTRAINT market_template_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_access
    ADD CONSTRAINT oauth2_access_user_id_client_id_key UNIQUE (user_id, client_id);

ALTER TABLE ONLY oauth2_client_groups
    ADD CONSTRAINT oauth2_client_groups_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_clients
    ADD CONSTRAINT oauth2_clients_client_id_key UNIQUE (client_id);

ALTER TABLE ONLY oauth2_clients
    ADD CONSTRAINT oauth2_clients_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_client_id_group_id_key UNIQUE (client_id, group_id);

ALTER TABLE ONLY oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_clients
    ADD CONSTRAINT oauth2_clients_unique_name UNIQUE (name);

ALTER TABLE ONLY oauth2_history
    ADD CONSTRAINT oauth2_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_scopes
    ADD CONSTRAINT oauth2_scopes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (refresh_token);

ALTER TABLE ONLY oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_user_id_client_id_key UNIQUE (user_id, client_id);

ALTER TABLE ONLY payment_history
    ADD CONSTRAINT payment_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY payment_plans
    ADD CONSTRAINT payment_plans_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cce_exec_time
    ADD CONSTRAINT pk_cce_exec_time PRIMARY KEY (conveyor_id, node_id, ts);

ALTER TABLE ONLY conveyor_billing
    ADD CONSTRAINT pk_conveyor_billing PRIMARY KEY (conveyor_id, user_id, ts);

ALTER TABLE ONLY conveyor_called_timers
    ADD CONSTRAINT pk_conveyor_called_timers PRIMARY KEY (conveyor_id, node_id, ts);

ALTER TABLE ONLY payments_history
    ADD CONSTRAINT pk_payments_history PRIMARY KEY (id_pk);

ALTER TABLE ONLY user_billing_stats
    ADD CONSTRAINT pk_user_billing_stats PRIMARY KEY (id_pk);

ALTER TABLE ONLY user_billing_tacts
    ADD CONSTRAINT pk_user_billing_tacts PRIMARY KEY (id_pk);

ALTER TABLE ONLY project_envs
    ADD CONSTRAINT projects_envs_pkey PRIMARY KEY (id);

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);

ALTER TABLE ONLY starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (obj_id, obj_type, user_id);

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_dashboards
    ADD CONSTRAINT user_dashboards_pkey PRIMARY KEY (group_id, dashboard_id, level);

ALTER TABLE ONLY user_folders
    ADD CONSTRAINT user_folders_pkey PRIMARY KEY (group_id, folder_id, level);

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_projects
    ADD CONSTRAINT user_projects_pkey PRIMARY KEY (project_id, group_id);

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_to_companies
    ADD CONSTRAINT user_to_companies_pkey PRIMARY KEY (company_id, user_id);

ALTER TABLE ONLY user_to_payment_plan
    ADD CONSTRAINT user_to_payment_plan_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_to_user_groups
    ADD CONSTRAINT user_to_user_groups_pkey PRIMARY KEY (user_group_id, user_id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (key);

CREATE UNIQUE INDEX api_callbacks_hash_id ON api_callbacks USING btree (hash);
CREATE INDEX client_id_idx ON oauth2_scopes USING btree (client_id);
CREATE UNIQUE INDEX companies_company_id_owner_user_id ON companies USING btree (id, owner_user_id);
CREATE INDEX conveyor_called_timers_conv_id_ts ON conveyor_called_timers USING btree (conveyor_id, ts);
CREATE INDEX conveyor_called_timers_ts ON conveyor_called_timers USING btree (ts);
CREATE UNIQUE INDEX conveyor_to_shard_conveyor_id ON conveyor_to_shard USING btree (conveyor_id, shard);
CREATE INDEX conveyors_name ON conveyors USING btree (lower((name)::text) varchar_pattern_ops);
CREATE INDEX conveyors_status ON conveyors USING btree (status);
CREATE INDEX external_services_hash ON external_services USING btree (hash);
CREATE UNIQUE INDEX folder_content_folder_id_obj_type_obj_id ON folder_content USING btree (folder_id, obj_type, obj_id);
CREATE INDEX folder_content_obj_id_obj_type ON folder_content USING btree (obj_type, obj_id);
CREATE INDEX folder_content_obj_type_obj_id ON folder_content USING btree (obj_type, obj_id);
CREATE INDEX folders_owner_id_type_status ON folders USING btree (owner_id, type, status);
CREATE INDEX folders_status_type ON folders USING btree (status, type);
CREATE INDEX history_obj_id_obj_type_change_time ON history USING btree (obj_id, obj_type, change_time);
CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON conveyor_billing USING btree (conveyor_id, ts);
CREATE INDEX ix_conveyor_billing_id ON conveyor_billing USING btree (id);
CREATE INDEX ix_conveyor_billing_ts ON conveyor_billing USING btree (ts);
CREATE INDEX ix_conveyor_billing_user_id_ts ON conveyor_billing USING btree (user_id, ts);
CREATE UNIQUE INDEX logins_login_type ON logins USING btree (login, type);
CREATE INDEX obj_id_obj_type_history_v2_rows ON history_v2_rows USING btree (obj_id, obj_type);
CREATE INDEX obj_to_obj_to_id_history_v2_rows ON history_v2_rows USING btree (obj_to, obj_to_id);
CREATE INDEX owner_id ON conveyors USING btree (owner_id);
CREATE UNIQUE INDEX payment_history_order_by_user ON payments_history USING btree (user_id, order_id);
CREATE UNIQUE INDEX payment_history_order_id ON payments_history USING btree (order_id);
CREATE INDEX payment_history_user_id ON user_to_payment_plan USING btree (user_id);
CREATE INDEX subscriptions_user_id_plan_id ON user_to_payment_plan USING btree (user_id, plan_id);
CREATE UNIQUE INDEX u_idx_client_id_name_scopes ON oauth2_scopes USING btree (client_id, name);
CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON user_billing_stats USING btree (user_id, conveyor_id, "timestamp");
CREATE INDEX user_billing_tacts_user_to_timestamp ON user_billing_stats USING btree (user_id, "timestamp");
CREATE INDEX user_folders_folder_id ON user_folders USING btree (folder_id);
CREATE INDEX user_group_privilegies_conveyor_id ON user_group_privilegies USING btree (conveyor_id);
CREATE INDEX user_group_privilegies_group_id ON user_group_privilegies USING btree (group_id);
CREATE INDEX user_group_privilegies_group_id_conveyor_id ON user_group_privilegies USING btree (group_id, conveyor_id);
CREATE UNIQUE INDEX user_group_privilegies_group_id_conveyor_id_node_id_prioritet ON user_group_privilegies USING btree (group_id, conveyor_id, node_id, prioritet) WHERE (node_id IS NOT NULL);
CREATE INDEX user_groups_owner_user_id_idx ON user_groups USING btree (owner_user_id);
CREATE INDEX user_to_payment_plan_user_id_plan_id ON user_to_payment_plan USING btree (user_id, plan_id);
CREATE INDEX user_to_user_groups_user_id ON user_to_user_groups USING btree (user_id);
