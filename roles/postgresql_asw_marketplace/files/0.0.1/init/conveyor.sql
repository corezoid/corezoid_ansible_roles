

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE TYPE public.history_v2_level AS ENUM (
    'OK',
    'ERROR'
);



CREATE TYPE public.history_v2_rows_severity AS ENUM (
    'INFO',
    'WARN',
    'ERROR'
);



CREATE FUNCTION public.disconnect_inherits_table(v_table_master text, v_date timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
v_no_inherit_ddl text:='';   --Общий скрипт отключения партиции от наследования
v_rec            record;     --Переменная курсора
BEGIN
  FOR v_rec IN (SELECT tp.partition_table pt
		FROM pg_class pgc
		INNER JOIN table_partition tp ON tp.partition_table = pgc.relname
		WHERE tp.master_table = v_table_master AND tp.is_inherit = 1 AND tp.start_range::int < extract(epoch from v_date))
	  LOOP
	        v_no_inherit_ddl := 'ALTER TABLE ' || v_rec.pt || ' NO INHERIT ' || v_table_master;
		EXECUTE v_no_inherit_ddl;
		UPDATE table_partition SET is_inherit = 0 WHERE partition_table = v_rec.pt;
	  END LOOP;
RETURN;
END;	  
$$;


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.aliases (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(128) NOT NULL,
    company_id character varying(25) NOT NULL,
    project_id integer DEFAULT 0 NOT NULL,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    obj_id integer,
    obj_type smallint,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    description character varying(2000),
    hash character varying(40)
);



CREATE SEQUENCE public.aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.aliases_id_seq OWNED BY public.aliases.id;



CREATE TABLE public.api_callbacks (
    conveyor_id integer NOT NULL,
    hash character(40) NOT NULL,
    data text
);



CREATE TABLE public.cce_exec_time (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    sum_time real NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    sum_success integer,
    sum_error integer
);



CREATE TABLE public.channel_storage (
    conveyor_id integer NOT NULL,
    channel character varying(100) NOT NULL,
    data text
);



CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    owner_user_id integer NOT NULL,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    server_id integer,
    company_id character varying(25) NOT NULL,
    status smallint DEFAULT 1,
    blocked_reason character varying(2000) DEFAULT NULL::character varying
);



CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;



CREATE TABLE public.configs (
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
    config text,
    ext_obj_id integer,
    obj_ref character varying(128)
);



CREATE SEQUENCE public.configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.configs_id_seq OWNED BY public.configs.id;



CREATE TABLE public.conveyor_billing (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    ts integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size bigint NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.conveyor_billing_daily (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    _time_point_end integer NOT NULL
);



CREATE TABLE public.conveyor_billing_hourly (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    _time_point_end integer NOT NULL
);



CREATE TABLE public.conveyor_billing_weekly (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    _time_point_end integer NOT NULL
);



CREATE TABLE public.conveyor_called_timers (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    called_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.conveyor_id_to_conveyor_ref (
    conveyor_ref character varying(255) NOT NULL,
    env character varying(10) NOT NULL,
    conveyor_id integer NOT NULL
);



CREATE TABLE public.conveyor_to_shard (
    conveyor_id integer NOT NULL,
    shard character varying(255) NOT NULL
);



CREATE TABLE public.conveyors (
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



CREATE SEQUENCE public.conveyors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.conveyors_id_seq OWNED BY public.conveyors.id;



CREATE TABLE public.dashboards (
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



CREATE SEQUENCE public.dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;



CREATE SEQUENCE public.env_var_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.env_vars (
    id bigint DEFAULT nextval('public.env_var_id_seq'::regclass) NOT NULL,
    conf_alias character varying(128),
    company_id character varying(25),
    data text,
    title character varying(255) NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);



CREATE TABLE public.esc_conv_to_convs (
    esc_conv integer NOT NULL,
    conv integer NOT NULL
);



CREATE SEQUENCE public.external_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.external_services (
    id integer DEFAULT nextval('public.external_services_id_seq'::regclass) NOT NULL,
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
    hash character varying(40) NOT NULL,
    ext_obj_id integer
);



CREATE TABLE public.folder_content (
    folder_id integer NOT NULL,
    obj_type integer NOT NULL,
    obj_id integer NOT NULL,
    id bigint NOT NULL
);



CREATE SEQUENCE public.folder_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.folder_content_id_seq OWNED BY public.folder_content.id;



CREATE TABLE public.folders (
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



CREATE SEQUENCE public.folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.folders_id_seq OWNED BY public.folders.id;



CREATE TABLE public.group_to_group (
    parent_group_id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL
);



CREATE TABLE public.history (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL,
    change_time integer NOT NULL,
    title text,
    action_type smallint,
    id bigint NOT NULL
);



CREATE SEQUENCE public.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.history_id_seq OWNED BY public.history.id;



CREATE TABLE public.history_v2 (
    id integer NOT NULL,
    create_time integer NOT NULL,
    level public.history_v2_level DEFAULT 'OK'::public.history_v2_level,
    path text,
    vsn integer,
    user_id integer,
    service character varying(50),
    ip character varying(39),
    request text NOT NULL,
    response text NOT NULL
);



CREATE SEQUENCE public.history_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.history_v2_id_seq OWNED BY public.history_v2.id;



CREATE TABLE public.history_v2_rows (
    id integer NOT NULL,
    history_id integer,
    severity public.history_v2_rows_severity DEFAULT 'INFO'::public.history_v2_rows_severity,
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



CREATE SEQUENCE public.history_v2_rows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.history_v2_rows_id_seq OWNED BY public.history_v2_rows.id;



CREATE SEQUENCE public.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.instances (
    id integer DEFAULT nextval('public.instances_id_seq'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    type smallint DEFAULT 0,
    status smallint DEFAULT 1,
    company_id character varying(25),
    data text
);



CREATE TABLE public.keystore (
    id integer NOT NULL,
    created timestamp with time zone,
    encrypted_key bytea,
    status integer
);



CREATE SEQUENCE public.keystore_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.keystore_id_seq OWNED BY public.keystore.id;



CREATE TABLE public.limits (
    id bigint NOT NULL,
    parent_limit_id bigint NOT NULL,
    obj_id character varying(255) DEFAULT '0'::character varying,
    obj_type smallint NOT NULL,
    company_id character varying(255) DEFAULT '0'::character varying,
    limit_type smallint NOT NULL,
    limit_value bigint,
    used_limit bigint DEFAULT 0
);



CREATE SEQUENCE public.limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_id_seq OWNED BY public.limits.id;



CREATE SEQUENCE public.limits_parent_limit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_parent_limit_id_seq OWNED BY public.limits.parent_limit_id;



CREATE TABLE public.login_to_users (
    user_id integer NOT NULL,
    login_id integer NOT NULL
);



CREATE TABLE public.logins (
    id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    login character varying(100) NOT NULL,
    type smallint NOT NULL,
    hash1 character varying(255),
    hash2 character varying(255),
    hash1_change_time integer,
    hash1_change_time_last_expire_notification integer
);



CREATE SEQUENCE public.logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.logins_id_seq OWNED BY public.logins.id;



CREATE TABLE public.market_template_history (
    id integer NOT NULL,
    market_template_id integer NOT NULL,
    description text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    last_editor_id integer
);



CREATE SEQUENCE public.market_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.market_history_id_seq OWNED BY public.market_template_history.id;



CREATE TABLE public.market_template (
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



CREATE SEQUENCE public.market_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.market_id_seq OWNED BY public.market_template.id;



CREATE TABLE public.oauth2_access (
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    scope text
);



CREATE TABLE public.oauth2_client_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    privs text,
    description text,
    status integer DEFAULT 0
);



CREATE SEQUENCE public.oauth2_client_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_client_groups_id_seq OWNED BY public.oauth2_client_groups.id;



CREATE TABLE public.oauth2_clients (
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
    scope text,
    full_name character varying(255)
);



CREATE SEQUENCE public.oauth2_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_clients_id_seq OWNED BY public.oauth2_clients.id;



CREATE TABLE public.oauth2_clients_to_groups (
    id integer NOT NULL,
    client_id integer NOT NULL,
    group_id integer NOT NULL
);



CREATE SEQUENCE public.oauth2_clients_to_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_clients_to_groups_id_seq OWNED BY public.oauth2_clients_to_groups.id;



CREATE TABLE public.oauth2_history (
    id integer NOT NULL,
    client_id integer NOT NULL,
    event_type character varying(255) NOT NULL,
    data text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);



CREATE SEQUENCE public.oauth2_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_history_id_seq OWNED BY public.oauth2_history.id;



CREATE TABLE public.oauth2_scopes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    client_id integer
);



CREATE SEQUENCE public.oauth2_scopes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_scopes_id_seq OWNED BY public.oauth2_scopes.id;



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



CREATE TABLE public.payment_history (
    id integer NOT NULL,
    order_id character(24),
    user_id integer,
    "time" integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    card character(4),
    amount smallint,
    plan_id smallint,
    event_type character varying(40)
);



CREATE SEQUENCE public.payment_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.payment_history_id_seq OWNED BY public.payment_history.id;



CREATE TABLE public.payment_plans (
    id integer NOT NULL,
    title character(24),
    stripe_plan_id character(24),
    amount integer,
    tps integer,
    tacts bigint,
    currency character(3),
    "interval" character(10)
);



CREATE SEQUENCE public.payment_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.payment_plans_id_seq OWNED BY public.payment_plans.id;



CREATE SEQUENCE public.payments_history_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.payments_history (
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
    card_expire_date integer,
    id_pk integer DEFAULT nextval('public.payments_history_id_pk_seq'::regclass) NOT NULL
);



CREATE TABLE public.project_envs (
    id integer NOT NULL,
    type smallint DEFAULT 1,
    status smallint DEFAULT 1,
    folder_id integer,
    vsn_major smallint DEFAULT 0,
    vsn_minor smallint DEFAULT 0,
    vsn_patch smallint DEFAULT 0,
    active boolean DEFAULT false,
    project_id integer NOT NULL
);



CREATE SEQUENCE public.project_envs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.project_envs_id_seq OWNED BY public.project_envs.id;



CREATE TABLE public.project_to_project_envs (
    project_env_id integer NOT NULL,
    project_id integer NOT NULL
);



CREATE TABLE public.projects (
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



CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;



CREATE TABLE public.single_account_api_keys (
    id integer NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text,
    api_user_id integer NOT NULL,
    api_login text NOT NULL,
    api_login_id integer NOT NULL
);



CREATE SEQUENCE public.single_account_api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.single_account_api_keys_id_seq OWNED BY public.single_account_api_keys.id;



CREATE TABLE public.starred_objects (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL
);



CREATE TABLE public.stat (
    id integer NOT NULL,
    type text,
    ts integer,
    component text,
    "publicKey" text,
    payload text
);



CREATE SEQUENCE public.stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.stat_id_seq OWNED BY public.stat.id;



CREATE TABLE public.subscriptions (
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



CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;



CREATE VIEW public.test AS
 SELECT (1 + 1);



CREATE SEQUENCE public.user_billing_stats_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.user_billing_stats (
    user_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    conveyor_tacts bigint,
    "timestamp" integer,
    "interval" integer,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('public.user_billing_stats_id_pk_seq'::regclass) NOT NULL
);



CREATE SEQUENCE public.user_billing_tacts_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.user_billing_tacts (
    user_id integer NOT NULL,
    tacts bigint NOT NULL,
    "timestamp" integer NOT NULL,
    "interval" integer NOT NULL,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('public.user_billing_tacts_id_pk_seq'::regclass) NOT NULL
);



CREATE SEQUENCE public.user_configs_id_pk_seq
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.user_configs (
    config_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text,
    id_pk integer DEFAULT nextval('public.user_configs_id_pk_seq'::regclass) NOT NULL
);



CREATE TABLE public.user_dashboards (
    dashboard_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);



CREATE TABLE public.user_external_services (
    ext_id integer NOT NULL,
    group_id integer NOT NULL,
    privs text
);



CREATE TABLE public.user_folders (
    folder_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);



CREATE TABLE public.user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24),
    prioritet smallint,
    privs text
);



CREATE SEQUENCE public.user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_group_privilegies_id_seq OWNED BY public.user_group_privilegies.id;



CREATE TABLE public.user_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    status smallint DEFAULT 1,
    company_id character varying(25),
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_user_id integer
);



CREATE SEQUENCE public.user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_groups_id_seq OWNED BY public.user_groups.id;



CREATE TABLE public.user_instances (
    instance_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);



CREATE TABLE public.user_projects (
    project_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);



CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer
);



CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;



CREATE TABLE public.user_to_2fa (
    user_id integer NOT NULL,
    type smallint DEFAULT 0,
    password character varying(32)
);



CREATE TABLE public.user_to_companies (
    id integer NOT NULL,
    company_id character varying(25) NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    status boolean DEFAULT true NOT NULL
);



CREATE SEQUENCE public.user_to_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_to_companies_id_seq OWNED BY public.user_to_companies.id;



CREATE TABLE public.user_to_payment_plan (
    user_id integer NOT NULL,
    status smallint,
    card character(4),
    expire_date integer,
    plan_id integer,
    max_rps integer DEFAULT 0,
    tacts_remain bigint DEFAULT 0
);



CREATE TABLE public.user_to_user_groups (
    user_group_id integer NOT NULL,
    user_id integer NOT NULL
);



CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    status boolean DEFAULT true NOT NULL,
    data text,
    last_entrance integer DEFAULT (date_part('epoch'::text, now()))::integer,
    lang character varying(2),
    ext_id integer,
    blocked_reason character varying(2000) DEFAULT NULL::character varying,
    ext_user_id integer
);



CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;



CREATE TABLE public.web_settings (
    key character(50) NOT NULL,
    value text
);



ALTER TABLE ONLY public.aliases ALTER COLUMN id SET DEFAULT nextval('public.aliases_id_seq'::regclass);



ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);



ALTER TABLE ONLY public.configs ALTER COLUMN id SET DEFAULT nextval('public.configs_id_seq'::regclass);



ALTER TABLE ONLY public.conveyors ALTER COLUMN id SET DEFAULT nextval('public.conveyors_id_seq'::regclass);



ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);



ALTER TABLE ONLY public.folder_content ALTER COLUMN id SET DEFAULT nextval('public.folder_content_id_seq'::regclass);



ALTER TABLE ONLY public.folders ALTER COLUMN id SET DEFAULT nextval('public.folders_id_seq'::regclass);



ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);



ALTER TABLE ONLY public.history_v2 ALTER COLUMN id SET DEFAULT nextval('public.history_v2_id_seq'::regclass);



ALTER TABLE ONLY public.history_v2_rows ALTER COLUMN id SET DEFAULT nextval('public.history_v2_rows_id_seq'::regclass);



ALTER TABLE ONLY public.keystore ALTER COLUMN id SET DEFAULT nextval('public.keystore_id_seq'::regclass);



ALTER TABLE ONLY public.limits ALTER COLUMN id SET DEFAULT nextval('public.limits_id_seq'::regclass);



ALTER TABLE ONLY public.limits ALTER COLUMN parent_limit_id SET DEFAULT nextval('public.limits_parent_limit_id_seq'::regclass);



ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);



ALTER TABLE ONLY public.market_template ALTER COLUMN id SET DEFAULT nextval('public.market_id_seq'::regclass);



ALTER TABLE ONLY public.market_template_history ALTER COLUMN id SET DEFAULT nextval('public.market_history_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_client_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_client_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients_to_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_to_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_history ALTER COLUMN id SET DEFAULT nextval('public.oauth2_history_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_scopes ALTER COLUMN id SET DEFAULT nextval('public.oauth2_scopes_id_seq'::regclass);



ALTER TABLE ONLY public.payment_history ALTER COLUMN id SET DEFAULT nextval('public.payment_history_id_seq'::regclass);



ALTER TABLE ONLY public.payment_plans ALTER COLUMN id SET DEFAULT nextval('public.payment_plans_id_seq'::regclass);



ALTER TABLE ONLY public.project_envs ALTER COLUMN id SET DEFAULT nextval('public.project_envs_id_seq'::regclass);



ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);



ALTER TABLE ONLY public.single_account_api_keys ALTER COLUMN id SET DEFAULT nextval('public.single_account_api_keys_id_seq'::regclass);



ALTER TABLE ONLY public.stat ALTER COLUMN id SET DEFAULT nextval('public.stat_id_seq'::regclass);



ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);



ALTER TABLE ONLY public.user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('public.user_group_privilegies_id_seq'::regclass);



ALTER TABLE ONLY public.user_groups ALTER COLUMN id SET DEFAULT nextval('public.user_groups_id_seq'::regclass);



ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);



ALTER TABLE ONLY public.user_to_companies ALTER COLUMN id SET DEFAULT nextval('public.user_to_companies_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



ALTER TABLE ONLY public.aliases
    ADD CONSTRAINT aliases_hash_project_id_company_id_key UNIQUE (hash, project_id, company_id);



ALTER TABLE ONLY public.aliases
    ADD CONSTRAINT aliases_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.aliases
    ADD CONSTRAINT aliases_short_name_company_id_project_id_key UNIQUE (short_name, company_id, project_id);



ALTER TABLE ONLY public.api_callbacks
    ADD CONSTRAINT api_callbacks_pkey PRIMARY KEY (conveyor_id);



ALTER TABLE ONLY public.channel_storage
    ADD CONSTRAINT channel_storage_pkey PRIMARY KEY (conveyor_id, channel);



ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.conveyor_billing_daily
    ADD CONSTRAINT conveyor_billing_daily_constraint_1 PRIMARY KEY (conveyor_id, user_id, ts);



ALTER TABLE ONLY public.conveyor_billing_daily
    ADD CONSTRAINT conveyor_billing_daily_constraint_2 UNIQUE (conveyor_id, user_id, _time_point_end);



ALTER TABLE ONLY public.conveyor_billing_daily
    ADD CONSTRAINT conveyor_billing_daily_constraint_3 UNIQUE (conveyor_id, user_id, ts, period);



ALTER TABLE ONLY public.conveyor_billing_hourly
    ADD CONSTRAINT conveyor_billing_hourly_constraint_1 PRIMARY KEY (conveyor_id, user_id, ts);



ALTER TABLE ONLY public.conveyor_billing_hourly
    ADD CONSTRAINT conveyor_billing_hourly_constraint_2 UNIQUE (conveyor_id, user_id, _time_point_end);



ALTER TABLE ONLY public.conveyor_billing_hourly
    ADD CONSTRAINT conveyor_billing_hourly_constraint_3 UNIQUE (conveyor_id, user_id, ts, period);



ALTER TABLE ONLY public.conveyor_billing_weekly
    ADD CONSTRAINT conveyor_billing_weekly_constraint_1 PRIMARY KEY (conveyor_id, user_id, ts);



ALTER TABLE ONLY public.conveyor_billing_weekly
    ADD CONSTRAINT conveyor_billing_weekly_constraint_2 UNIQUE (conveyor_id, user_id, _time_point_end);



ALTER TABLE ONLY public.conveyor_billing_weekly
    ADD CONSTRAINT conveyor_billing_weekly_constraint_3 UNIQUE (conveyor_id, user_id, ts, period);



ALTER TABLE ONLY public.conveyor_id_to_conveyor_ref
    ADD CONSTRAINT conveyor_id_to_conveyor_ref_pkey PRIMARY KEY (conveyor_ref, env);



ALTER TABLE ONLY public.conveyor_to_shard
    ADD CONSTRAINT conveyor_to_shard_pkey PRIMARY KEY (conveyor_id, shard);



ALTER TABLE ONLY public.conveyors
    ADD CONSTRAINT conveyors_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.env_vars
    ADD CONSTRAINT env_vars_id_status_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.esc_conv_to_convs
    ADD CONSTRAINT esc_conv_to_convs_pkey PRIMARY KEY (esc_conv, conv);



ALTER TABLE ONLY public.external_services
    ADD CONSTRAINT external_services_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.folder_content
    ADD CONSTRAINT folder_content_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.group_to_group
    ADD CONSTRAINT group_to_group_pkey PRIMARY KEY (parent_group_id, group_id, conveyor_id);



ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.history_v2
    ADD CONSTRAINT history_v2_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.history_v2_rows
    ADD CONSTRAINT history_v2_rows_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.keystore
    ADD CONSTRAINT keystore_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.limits
    ADD CONSTRAINT limits_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);



ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.market_template_history
    ADD CONSTRAINT market_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.market_template
    ADD CONSTRAINT market_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_access
    ADD CONSTRAINT oauth2_access_pkey PRIMARY KEY (user_id, client_id);



ALTER TABLE ONLY public.oauth2_client_groups
    ADD CONSTRAINT oauth2_client_groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_client_id_key UNIQUE (client_id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_client_id_group_id_key UNIQUE (client_id, group_id);



ALTER TABLE ONLY public.oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_unique_name UNIQUE (name);



ALTER TABLE ONLY public.oauth2_history
    ADD CONSTRAINT oauth2_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_scopes
    ADD CONSTRAINT oauth2_scopes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (refresh_token);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_user_id_client_id_key UNIQUE (user_id, client_id);



ALTER TABLE ONLY public.payment_history
    ADD CONSTRAINT payment_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.payment_plans
    ADD CONSTRAINT payment_plans_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.cce_exec_time
    ADD CONSTRAINT pk_cce_exec_time PRIMARY KEY (conveyor_id, node_id, ts);



ALTER TABLE ONLY public.conveyor_billing
    ADD CONSTRAINT pk_conveyor_billing PRIMARY KEY (conveyor_id, user_id, ts);



ALTER TABLE ONLY public.conveyor_called_timers
    ADD CONSTRAINT pk_conveyor_called_timers PRIMARY KEY (conveyor_id, node_id, ts);



ALTER TABLE ONLY public.payments_history
    ADD CONSTRAINT pk_payments_history PRIMARY KEY (id_pk);



ALTER TABLE ONLY public.user_billing_stats
    ADD CONSTRAINT pk_user_billing_stats PRIMARY KEY (id_pk);



ALTER TABLE ONLY public.user_billing_tacts
    ADD CONSTRAINT pk_user_billing_tacts PRIMARY KEY (id_pk);



ALTER TABLE ONLY public.user_configs
    ADD CONSTRAINT pk_user_configs PRIMARY KEY (id_pk);



ALTER TABLE ONLY public.project_to_project_envs
    ADD CONSTRAINT project_to_project_envs_pkey PRIMARY KEY (project_env_id, project_id);



ALTER TABLE ONLY public.project_envs
    ADD CONSTRAINT projects_envs_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.single_account_api_keys
    ADD CONSTRAINT single_account_api_keys_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (obj_id, obj_type, user_id);



ALTER TABLE ONLY public.stat
    ADD CONSTRAINT stat_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_dashboards
    ADD CONSTRAINT user_dashboards_pkey PRIMARY KEY (group_id, dashboard_id, level);



ALTER TABLE ONLY public.user_external_services
    ADD CONSTRAINT user_external_services_pkey PRIMARY KEY (group_id, ext_id);



ALTER TABLE ONLY public.user_folders
    ADD CONSTRAINT user_folders_pkey PRIMARY KEY (group_id, folder_id, level);



ALTER TABLE ONLY public.user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_instances
    ADD CONSTRAINT user_instances_pkey PRIMARY KEY (group_id, instance_id, level);



ALTER TABLE ONLY public.user_projects
    ADD CONSTRAINT user_projects_pkey PRIMARY KEY (project_id, group_id, level);



ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_to_2fa
    ADD CONSTRAINT user_to_2fa_pkey PRIMARY KEY (user_id);



ALTER TABLE ONLY public.user_to_companies
    ADD CONSTRAINT user_to_companies_pkey PRIMARY KEY (company_id, user_id);



ALTER TABLE ONLY public.user_to_payment_plan
    ADD CONSTRAINT user_to_payment_plan_pkey PRIMARY KEY (user_id);



ALTER TABLE ONLY public.user_to_user_groups
    ADD CONSTRAINT user_to_user_groups_pkey PRIMARY KEY (user_group_id, user_id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_ext_id_key UNIQUE (ext_id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (key);



CREATE UNIQUE INDEX api_callbacks_hash_id ON public.api_callbacks USING btree (hash);



CREATE UNIQUE INDEX companies_company_id_owner_user_id ON public.companies USING btree (id, owner_user_id);



CREATE INDEX configs_obj_id_obj_ref_idx ON public.configs USING btree (ext_obj_id, obj_ref);



CREATE UNIQUE INDEX conveyor_to_shard_conveyor_id ON public.conveyor_to_shard USING btree (conveyor_id, shard);



CREATE INDEX conveyors_id_status ON public.conveyors USING btree (id, status);



CREATE INDEX conveyors_name ON public.conveyors USING btree (lower((name)::text) varchar_pattern_ops);



CREATE INDEX conveyors_owner_id_company_id_status_type ON public.conveyors USING btree (owner_id, status, company_id);



CREATE INDEX dashboards_id_status ON public.dashboards USING btree (id, status);



CREATE INDEX dashboards_owner_id_company_id_status ON public.dashboards USING btree (owner_id, status, company_id);



CREATE UNIQUE INDEX env_vars_company_id_alias_uniq_pkey ON public.env_vars USING btree ((COALESCE(company_id, ''::character varying)), conf_alias);



CREATE INDEX esc_conv_to_convs_esc_conv_conv ON public.esc_conv_to_convs USING btree (esc_conv, conv);



CREATE INDEX ext_srv_obj_id_idx ON public.external_services USING btree (ext_obj_id);



CREATE INDEX external_services_hash ON public.external_services USING btree (hash);



CREATE INDEX external_services_id_status ON public.external_services USING btree (id, status);



CREATE UNIQUE INDEX folder_content_folder_id_obj_type_obj_id ON public.folder_content USING btree (folder_id, obj_type, obj_id);



CREATE INDEX folder_content_obj_id_obj_type ON public.folder_content USING btree (obj_type, obj_id);



CREATE INDEX folders_id_status ON public.folders USING btree (id, status);



CREATE INDEX folders_owner_id_company_id_status_type ON public.folders USING btree (owner_id, status, type, company_id);



CREATE INDEX history_obj_id_obj_type_change_time ON public.history USING btree (obj_id, obj_type, change_time);



CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON public.conveyor_billing USING btree (conveyor_id, ts);



CREATE INDEX ix_conveyor_billing_ts ON public.conveyor_billing USING btree (ts);



CREATE INDEX ix_conveyor_billing_user_id_ts ON public.conveyor_billing USING btree (user_id, ts);



CREATE UNIQUE INDEX limits_obj_id_obj_type_company_id_limit_type ON public.limits USING btree (obj_id, obj_type, company_id, limit_type);



CREATE UNIQUE INDEX login_to_users_login_id_user_id ON public.login_to_users USING btree (login_id, user_id);



CREATE UNIQUE INDEX logins_login_type ON public.logins USING btree (login, type);



CREATE UNIQUE INDEX payment_history_order_by_user ON public.payments_history USING btree (user_id, order_id);



CREATE UNIQUE INDEX payment_history_order_id ON public.payments_history USING btree (order_id);



CREATE INDEX payment_history_user_id ON public.user_to_payment_plan USING btree (user_id);



CREATE INDEX subscriptions_user_id_plan_id ON public.user_to_payment_plan USING btree (user_id, plan_id);



CREATE UNIQUE INDEX u_idx_client_id_name_scopes ON public.oauth2_scopes USING btree (client_id, name);



CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON public.user_billing_stats USING btree (user_id, conveyor_id, "timestamp");



CREATE INDEX user_billing_tacts_user_to_timestamp ON public.user_billing_stats USING btree (user_id, "timestamp");



CREATE UNIQUE INDEX user_configs_group_id_config_id_level ON public.user_configs USING btree (group_id, config_id, level);



CREATE UNIQUE INDEX user_external_services_group_id_ext_id ON public.user_external_services USING btree (group_id, ext_id);



CREATE UNIQUE INDEX user_group_privilegies_group_id_conveyor_id_node_id_prioritet ON public.user_group_privilegies USING btree (group_id, conveyor_id, node_id, prioritet) WHERE (node_id IS NOT NULL);



CREATE INDEX user_groups_owner_user_id_idx ON public.user_groups USING btree (owner_user_id);



CREATE INDEX user_to_payment_plan_user_id_plan_id ON public.user_to_payment_plan USING btree (user_id, plan_id);



CREATE INDEX user_to_user_groups_user_id ON public.user_to_user_groups USING btree (user_id);



