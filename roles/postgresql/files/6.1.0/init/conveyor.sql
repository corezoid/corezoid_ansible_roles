

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA public;



COMMENT ON SCHEMA public IS 'standard public schema';



CREATE TYPE public.history_v2_level AS ENUM (
    'OK',
    'ERROR'
);



CREATE TYPE public.history_v2_rows_severity AS ENUM (
    'INFO',
    'WARN',
    'ERROR'
);



CREATE FUNCTION public.count_estimate(query text) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
rec   record;
rows  integer;
BEGIN
FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
    rows := substring(rec."QUERY PLAN" FROM ' rows=([[:digit:]]+)');
    EXIT WHEN rows IS NOT NULL;
END LOOP;
  RETURN rows;
END;
$$;



CREATE FUNCTION public.update_conveyor_version() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
   _version int;
   _conveyor_id int;
BEGIN
     IF (TG_OP = 'DELETE') THEN
        _conveyor_id = OLD.conveyor_id;
        _version = NULL; -- drop version if delete conveyor_fdw
        UPDATE public.conveyors SET version = _version WHERE id = _conveyor_id and version IS NOT NULL;
     ELSIF (TG_OP = 'INSERT') THEN
        _conveyor_id = NEW.conveyor_id;
        _version = NEW.version;
        UPDATE public.conveyors SET version = _version WHERE id = _conveyor_id and version IS NULL;
     END IF;
     RETURN NEW;
EXCEPTION
    when sqlstate '40001' then
        RETURN NEW;
    END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;


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
    hash character varying(40),
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    description character varying(2000),
    status smallint DEFAULT 1,
    stage_id integer DEFAULT 0 NOT NULL,
    uuid character varying(36) DEFAULT NULL::character varying,
    name_temp character varying(255),
    description_temp text,
    status_temp smallint,
    short_name_temp character varying(128),
    hash_temp character varying(40),
    obj_id_temp integer,
    obj_type_temp smallint,
    version integer
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
    blocked_reason character varying(2000) DEFAULT NULL::character varying,
    auth_providers text
);



CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;



CREATE TABLE public.components_versions (
    id integer NOT NULL,
    component character varying(255) NOT NULL,
    ip character varying(255) NOT NULL,
    vsn character varying(255) NOT NULL,
    ts integer NOT NULL
);



CREATE SEQUENCE public.components_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.components_versions_id_seq OWNED BY public.components_versions.id;



CREATE SEQUENCE public.configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.configs (
    id integer DEFAULT nextval('public.configs_id_seq'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_id integer NOT NULL,
    type smallint DEFAULT 0,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25),
    data text
);



CREATE TABLE public.conveyor_billing (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    ts integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size bigint NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);



CREATE SEQUENCE public.conveyor_billing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.conveyor_billing_id_seq OWNED BY public.conveyor_billing.id;



CREATE TABLE public.conveyor_called_timers (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    called_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.conveyor_fdw (
    conveyor_id integer,
    status smallint,
    create_time integer,
    version integer
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
    version integer,
    uuid character varying(36) DEFAULT NULL::character varying,
    is_blocked boolean DEFAULT false,
    name_temp character varying(255),
    description_temp text,
    status_temp smallint,
    params_temp text,
    params_version integer DEFAULT 1,
    params_version_temp integer
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
    project_id integer,
    uuid character varying(36) DEFAULT NULL::character varying,
    title_temp character varying(255),
    description_temp text,
    status_temp smallint,
    timerange_temp text,
    grid_temp text,
    version integer
);



CREATE SEQUENCE public.dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;



CREATE TABLE public.dbcall_instance_per_user (
    user_id integer NOT NULL,
    status smallint DEFAULT 1
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
    hash character varying(40) NOT NULL
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
    project_id integer,
    uuid character varying(36) DEFAULT NULL::character varying,
    title_temp character varying(255),
    description_temp text,
    status_temp smallint,
    version integer
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



CREATE TABLE public.instances (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    type smallint DEFAULT 0,
    status smallint DEFAULT 1,
    company_id character varying(25),
    data text,
    uuid character varying(36) DEFAULT NULL::character varying,
    title_temp character varying(255),
    description_temp text,
    status_temp smallint,
    data_temp text,
    version integer
);



CREATE SEQUENCE public.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.instances_id_seq OWNED BY public.instances.id;



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



CREATE TABLE public.market_template_history (
    id integer NOT NULL,
    market_template_id integer NOT NULL,
    description text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    last_editor_id integer
);



CREATE SEQUENCE public.market_template_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.market_template_history_id_seq OWNED BY public.market_template_history.id;



CREATE SEQUENCE public.market_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.market_template_id_seq OWNED BY public.market_template.id;



CREATE TABLE public.payment_history (
    id integer NOT NULL,
    order_id character(24),
    user_id integer,
    "time" integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    card character(4),
    amount smallint,
    plan_id smallint
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
    id_pk integer DEFAULT nextval('public.payments_history_id_pk_seq'::regclass) NOT NULL
);



CREATE TABLE public.project_entities (
    obj_id integer NOT NULL,
    obj_type integer NOT NULL,
    project_id integer DEFAULT 0 NOT NULL,
    stage_id integer DEFAULT 0 NOT NULL
);



CREATE TABLE public.projects (
    id integer NOT NULL,
    short_name character varying(128) NOT NULL,
    company_id character varying(25) NOT NULL,
    attributes text,
    status smallint DEFAULT 1
);



CREATE TABLE public.stages (
    id integer NOT NULL,
    project_id integer NOT NULL,
    short_name character varying(128) NOT NULL,
    immutable boolean DEFAULT false,
    company_id character varying(25) NOT NULL,
    attributes text,
    status smallint DEFAULT 1
);



CREATE TABLE public.starred_objects (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL
);



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
    START WITH 1
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
    password character varying(256)
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
    id integer NOT NULL,
    user_id integer,
    status smallint,
    card character(4),
    expire_date integer,
    plan_id integer
);



CREATE SEQUENCE public.user_to_payment_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_to_payment_plan_id_seq OWNED BY public.user_to_payment_plan.id;



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
    blocked_reason character varying(2000) DEFAULT NULL::character varying,
    ext_user_id integer,
    status2 smallint DEFAULT 1,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    login_locked_until integer
);



CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;



CREATE TABLE public.versions (
    id integer NOT NULL,
    project_id integer NOT NULL,
    vsn character varying(128) NOT NULL,
    name character varying(256),
    stage_id integer NOT NULL,
    changelog text,
    link character varying(2048),
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    file_format_vsn smallint DEFAULT 1,
    status smallint DEFAULT 1
);



CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;



CREATE TABLE public.web_settings (
    key character(50) NOT NULL,
    value text
);



ALTER TABLE ONLY public.aliases ALTER COLUMN id SET DEFAULT nextval('public.aliases_id_seq'::regclass);



ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);



ALTER TABLE ONLY public.components_versions ALTER COLUMN id SET DEFAULT nextval('public.components_versions_id_seq'::regclass);



ALTER TABLE ONLY public.conveyor_billing ALTER COLUMN id SET DEFAULT nextval('public.conveyor_billing_id_seq'::regclass);



ALTER TABLE ONLY public.conveyors ALTER COLUMN id SET DEFAULT nextval('public.conveyors_id_seq'::regclass);



ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);



ALTER TABLE ONLY public.folder_content ALTER COLUMN id SET DEFAULT nextval('public.folder_content_id_seq'::regclass);



ALTER TABLE ONLY public.folders ALTER COLUMN id SET DEFAULT nextval('public.folders_id_seq'::regclass);



ALTER TABLE ONLY public.history ALTER COLUMN id SET DEFAULT nextval('public.history_id_seq'::regclass);



ALTER TABLE ONLY public.history_v2 ALTER COLUMN id SET DEFAULT nextval('public.history_v2_id_seq'::regclass);



ALTER TABLE ONLY public.history_v2_rows ALTER COLUMN id SET DEFAULT nextval('public.history_v2_rows_id_seq'::regclass);



ALTER TABLE ONLY public.instances ALTER COLUMN id SET DEFAULT nextval('public.instances_id_seq'::regclass);



ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);



ALTER TABLE ONLY public.market_template ALTER COLUMN id SET DEFAULT nextval('public.market_template_id_seq'::regclass);



ALTER TABLE ONLY public.market_template_history ALTER COLUMN id SET DEFAULT nextval('public.market_template_history_id_seq'::regclass);



ALTER TABLE ONLY public.payment_history ALTER COLUMN id SET DEFAULT nextval('public.payment_history_id_seq'::regclass);



ALTER TABLE ONLY public.payment_plans ALTER COLUMN id SET DEFAULT nextval('public.payment_plans_id_seq'::regclass);



ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);



ALTER TABLE ONLY public.user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('public.user_group_privilegies_id_seq'::regclass);



ALTER TABLE ONLY public.user_groups ALTER COLUMN id SET DEFAULT nextval('public.user_groups_id_seq'::regclass);



ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);



ALTER TABLE ONLY public.user_to_companies ALTER COLUMN id SET DEFAULT nextval('public.user_to_companies_id_seq'::regclass);



ALTER TABLE ONLY public.user_to_payment_plan ALTER COLUMN id SET DEFAULT nextval('public.user_to_payment_plan_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);



ALTER TABLE ONLY public.aliases
    ADD CONSTRAINT aliases_hash_company_id_project_id_stage_id_key UNIQUE (hash, company_id, project_id, stage_id);



ALTER TABLE ONLY public.aliases
    ADD CONSTRAINT aliases_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.api_callbacks
    ADD CONSTRAINT api_callbacks_pkey PRIMARY KEY (conveyor_id);



ALTER TABLE ONLY public.channel_storage
    ADD CONSTRAINT channel_storage_pkey PRIMARY KEY (conveyor_id, channel);



ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.components_versions
    ADD CONSTRAINT components_versions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_group_privilegies
    ADD CONSTRAINT constraintname UNIQUE (group_id, conveyor_id);



ALTER TABLE ONLY public.conveyor_id_to_conveyor_ref
    ADD CONSTRAINT conveyor_id_to_conveyor_ref_pkey PRIMARY KEY (conveyor_ref, env);



ALTER TABLE ONLY public.conveyor_to_shard
    ADD CONSTRAINT conveyor_to_shard_pkey PRIMARY KEY (conveyor_id);



ALTER TABLE ONLY public.conveyors
    ADD CONSTRAINT conveyors_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.dbcall_instance_per_user
    ADD CONSTRAINT dbcall_instance_per_user_pkey PRIMARY KEY (user_id);



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



ALTER TABLE ONLY public.login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);



ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.market_template_history
    ADD CONSTRAINT market_template_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.market_template
    ADD CONSTRAINT market_template_pkey PRIMARY KEY (id);



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



ALTER TABLE ONLY public.project_entities
    ADD CONSTRAINT project_entities_pkey PRIMARY KEY (obj_id, obj_type, project_id, stage_id);



ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (obj_id, obj_type, user_id);



ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.components_versions
    ADD CONSTRAINT uniq UNIQUE (component, ip, vsn);



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



ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_to_2fa
    ADD CONSTRAINT user_to_2fa_pkey PRIMARY KEY (user_id);



ALTER TABLE ONLY public.user_to_companies
    ADD CONSTRAINT user_to_companies_pkey PRIMARY KEY (company_id, user_id);



ALTER TABLE ONLY public.user_to_payment_plan
    ADD CONSTRAINT user_to_payment_plan_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_to_user_groups
    ADD CONSTRAINT user_to_user_groups_pkey PRIMARY KEY (user_group_id, user_id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (key);



CREATE UNIQUE INDEX aliases_unique_short_name_company_id_project_id_stage_id_key ON public.aliases USING btree (short_name, company_id, project_id, stage_id) WHERE (status <> 3);



CREATE UNIQUE INDEX api_callbacks_hash_id ON public.api_callbacks USING btree (hash);



CREATE UNIQUE INDEX companies_company_id_owner_user_id ON public.companies USING btree (id, owner_user_id);



CREATE INDEX conveyor_called_timers_conv_id_ts ON public.conveyor_called_timers USING btree (conveyor_id, ts);



CREATE INDEX conveyor_called_timers_ts ON public.conveyor_called_timers USING btree (ts);



CREATE UNIQUE INDEX conveyor_fwd_conveyor_id_status ON public.conveyor_fdw USING btree (conveyor_id, status);



CREATE UNIQUE INDEX conveyor_to_shard_conveyor_id ON public.conveyor_to_shard USING btree (conveyor_id, shard);



CREATE INDEX conveyors_name ON public.conveyors USING btree (lower((name)::text) varchar_pattern_ops);



CREATE INDEX conveyors_status ON public.conveyors USING btree (status);



CREATE INDEX external_services_hash ON public.external_services USING btree (hash);



CREATE UNIQUE INDEX folder_content_folder_id_obj_type_obj_id ON public.folder_content USING btree (folder_id, obj_type, obj_id);



CREATE INDEX folder_content_obj_id_obj_type ON public.folder_content USING btree (obj_type, obj_id);



CREATE INDEX folder_content_obj_type_obj_id ON public.folder_content USING btree (obj_type, obj_id);



CREATE INDEX folders_owner_id_type_status ON public.folders USING btree (owner_id, type, status);



CREATE INDEX folders_status_type ON public.folders USING btree (status, type);



CREATE INDEX history_obj_id_obj_type_change_time ON public.history USING btree (obj_id, obj_type, change_time);



CREATE INDEX history_v2_create_time_idx ON public.history_v2 USING btree (create_time DESC);



CREATE INDEX history_v2_level_user_id_create_time_idx ON public.history_v2 USING btree (level, user_id, create_time DESC);



CREATE INDEX history_v2_rows_history_id_idx ON public.history_v2_rows USING btree (history_id);



CREATE INDEX history_v2_rows_severity_type_obj_company_id_idx ON public.history_v2_rows USING btree (severity, type, obj, company_id);



CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON public.conveyor_billing USING btree (conveyor_id, ts);



CREATE INDEX ix_conveyor_billing_id ON public.conveyor_billing USING btree (id);



CREATE INDEX ix_conveyor_billing_ts ON public.conveyor_billing USING btree (ts);



CREATE INDEX ix_conveyor_billing_user_id_ts ON public.conveyor_billing USING btree (user_id, ts);



CREATE UNIQUE INDEX logins_login_type ON public.logins USING btree (login, type);



CREATE INDEX obj_id_obj_type_history_v2_rows ON public.history_v2_rows USING btree (obj_id, obj_type);



CREATE INDEX obj_to_obj_to_id_history_v2_rows ON public.history_v2_rows USING btree (obj_to, obj_to_id);



CREATE INDEX owner_id ON public.conveyors USING btree (owner_id);



CREATE UNIQUE INDEX payment_history_order_by_user ON public.payments_history USING btree (user_id, order_id);



CREATE UNIQUE INDEX payment_history_order_id ON public.payments_history USING btree (order_id);



CREATE INDEX payment_history_user_id ON public.user_to_payment_plan USING btree (user_id);



CREATE UNIQUE INDEX project_entities_obj_id_obj_type ON public.project_entities USING btree (obj_id, obj_type);



CREATE INDEX project_entities_obj_type_stage_id ON public.project_entities USING btree (obj_type, stage_id);



CREATE UNIQUE INDEX projects_unique_short_name ON public.projects USING btree (short_name, company_id) WHERE (status <> 3);



CREATE UNIQUE INDEX stages_unique_short_name ON public.stages USING btree (short_name, project_id) WHERE (status <> 3);



CREATE INDEX subscriptions_user_id_plan_id ON public.user_to_payment_plan USING btree (user_id, plan_id);



CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON public.user_billing_stats USING btree (user_id, conveyor_id, "timestamp");



CREATE INDEX user_billing_tacts_user_to_timestamp ON public.user_billing_stats USING btree (user_id, "timestamp");



CREATE UNIQUE INDEX user_configs_group_id_config_id_level ON public.user_configs USING btree (group_id, config_id, level);



CREATE UNIQUE INDEX user_external_services_group_id_ext_id ON public.user_external_services USING btree (group_id, ext_id);



CREATE INDEX user_folders_folder_id ON public.user_folders USING btree (folder_id);



CREATE INDEX user_group_privilegies_conveyor_id ON public.user_group_privilegies USING btree (conveyor_id);



CREATE INDEX user_group_privilegies_group_id ON public.user_group_privilegies USING btree (group_id);



CREATE INDEX user_group_privilegies_group_id_conveyor_id ON public.user_group_privilegies USING btree (group_id, conveyor_id);



CREATE INDEX user_groups_owner_user_id_idx ON public.user_groups USING btree (owner_user_id);



CREATE INDEX user_to_payment_plan_user_id_plan_id ON public.user_to_payment_plan USING btree (user_id, plan_id);



CREATE INDEX user_to_user_groups_user_id ON public.user_to_user_groups USING btree (user_id);



CREATE UNIQUE INDEX versions_unique_vsn ON public.versions USING btree (vsn, project_id) WHERE (status <> 3);



CREATE CONSTRAINT TRIGGER update_conveyor_version AFTER INSERT OR DELETE ON public.conveyor_fdw NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION public.update_conveyor_version();



