

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


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.charts (
    id character(24) NOT NULL,
    dashboard_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    settings text,
    series text,
    chart_type character varying(40) DEFAULT NULL::character varying,
    uuid character varying(36) DEFAULT NULL::character varying,
    name_temp character varying(255),
    description_temp text,
    status smallint DEFAULT 1 NOT NULL,
    status_temp smallint,
    settings_temp text,
    series_temp text,
    chart_type_temp character varying(20),
    version integer
);



CREATE FOREIGN TABLE public.conveyor_fdw (
    conveyor_id integer,
    status smallint,
    create_time integer,
    version integer
)
SERVER conveyor_wrapper
OPTIONS (
    schema_name 'public',
    table_name 'conveyor_fdw'
);
ALTER FOREIGN TABLE public.conveyor_fdw ALTER COLUMN conveyor_id OPTIONS (
    column_name 'conveyor_id'
);
ALTER FOREIGN TABLE public.conveyor_fdw ALTER COLUMN status OPTIONS (
    column_name 'status'
);
ALTER FOREIGN TABLE public.conveyor_fdw ALTER COLUMN create_time OPTIONS (
    column_name 'create_time'
);
ALTER FOREIGN TABLE public.conveyor_fdw ALTER COLUMN version OPTIONS (
    column_name 'version'
);



CREATE TABLE public.conveyor_params_access (
    id bigint NOT NULL,
    from_conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    ts integer NOT NULL,
    count integer NOT NULL,
    period integer NOT NULL
);



CREATE SEQUENCE public.conveyor_params_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.conveyor_params_access_id_seq OWNED BY public.conveyor_params_access.id;



CREATE TABLE public.node_commits_history (
    id bigint NOT NULL,
    user_id integer,
    conveyor_id integer,
    node_id character(24),
    version integer,
    name character varying(255),
    condition text,
    description text,
    x integer,
    y integer,
    extra text,
    status integer,
    type smallint,
    create_time integer,
    options text
);



CREATE SEQUENCE public.node_commits_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.node_commits_history_id_seq OWNED BY public.node_commits_history.id;



CREATE TABLE public.nodes (
    id character(24) NOT NULL,
    conveyor_id integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    condition text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    max_count integer DEFAULT 0 NOT NULL,
    max_time integer DEFAULT 0 NOT NULL,
    status smallint NOT NULL,
    x integer,
    y integer,
    extra text,
    version integer,
    condition_temp text,
    last_editor integer,
    last_change_time integer,
    name_temp character varying(255),
    description_temp text,
    extra_temp text,
    type_temp smallint,
    x_temp integer,
    y_temp integer,
    status_temp smallint DEFAULT 1,
    options text,
    options_temp text,
    uuid character varying(36) DEFAULT NULL::character varying
);



CREATE TABLE public.nodes_transits (
    id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    to_conveyor_id integer NOT NULL,
    to_node_id character(24) NOT NULL,
    prioritet smallint,
    convert text,
    description character varying(255)
);



CREATE SEQUENCE public.nodes_transits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.nodes_transits_id_seq OWNED BY public.nodes_transits.id;



CREATE TABLE public.register_stream_counters (
    id bigint NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    key character varying(100) NOT NULL,
    value numeric(50,5) NOT NULL,
    period integer NOT NULL
);



CREATE SEQUENCE public.register_stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.register_stream_counters_id_seq OWNED BY public.register_stream_counters.id;



CREATE TABLE public.stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.tasks (
    id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    dynamic_timer integer DEFAULT 0 NOT NULL,
    encrypted_data bytea
);



CREATE TABLE public.tasks_archive (
    id bigint NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    task_id character(24),
    encrypted_data bytea
);



CREATE SEQUENCE public.tasks_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tasks_archive_id_seq OWNED BY public.tasks_archive.id;



CREATE TABLE public.tasks_history (
    id bigint NOT NULL,
    task_id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    conveyor_prev_id integer,
    node_id character(24) NOT NULL,
    user_id integer,
    create_time bigint DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    node_prev_id character(24),
    status integer DEFAULT 1 NOT NULL,
    data text,
    prev_id integer DEFAULT 0,
    encrypted_data bytea
);



CREATE SEQUENCE public.tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tasks_history_id_seq OWNED BY public.tasks_history.id;



CREATE TABLE public.user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    type smallint NOT NULL,
    prioritet smallint
);



CREATE SEQUENCE public.user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_group_privilegies_id_seq OWNED BY public.user_group_privilegies.id;



ALTER TABLE ONLY public.conveyor_params_access ALTER COLUMN id SET DEFAULT nextval('public.conveyor_params_access_id_seq'::regclass);



ALTER TABLE ONLY public.node_commits_history ALTER COLUMN id SET DEFAULT nextval('public.node_commits_history_id_seq'::regclass);



ALTER TABLE ONLY public.nodes_transits ALTER COLUMN id SET DEFAULT nextval('public.nodes_transits_id_seq'::regclass);



ALTER TABLE ONLY public.register_stream_counters ALTER COLUMN id SET DEFAULT nextval('public.register_stream_counters_id_seq'::regclass);



ALTER TABLE ONLY public.tasks_archive ALTER COLUMN id SET DEFAULT nextval('public.tasks_archive_id_seq'::regclass);



ALTER TABLE ONLY public.tasks_history ALTER COLUMN id SET DEFAULT nextval('public.tasks_history_id_seq'::regclass);



ALTER TABLE ONLY public.user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('public.user_group_privilegies_id_seq'::regclass);



ALTER TABLE ONLY public.charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.node_commits_history
    ADD CONSTRAINT node_commits_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.nodes_transits
    ADD CONSTRAINT nodes_transits_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.conveyor_params_access
    ADD CONSTRAINT pk_conveyor_params_access PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, user_id);



ALTER TABLE ONLY public.register_stream_counters
    ADD CONSTRAINT pk_register_stream_counters PRIMARY KEY (conveyor_id, node_id, ts, key);



ALTER TABLE ONLY public.stream_counters
    ADD CONSTRAINT pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);



ALTER TABLE ONLY public.tasks_archive
    ADD CONSTRAINT tasks_archive_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);



CREATE INDEX charts_dashboard_id ON public.charts USING btree (dashboard_id);



CREATE INDEX charts_id_dashboard_id ON public.charts USING btree (id, dashboard_id);



CREATE INDEX conv_id_version_create_time ON public.node_commits_history USING btree (conveyor_id, version, create_time);



CREATE UNIQUE INDEX conveyor_id_uuid ON public.nodes USING btree (conveyor_id, uuid);



CREATE UNIQUE INDEX dashboard_id_uuid ON public.charts USING btree (dashboard_id, uuid);



CREATE INDEX ix_conveyor_params_access_id ON public.conveyor_params_access USING btree (id);



CREATE INDEX ix_register_stream_counters_id ON public.register_stream_counters USING btree (id);



CREATE INDEX nodes_conveyor_id ON public.nodes USING btree (conveyor_id);



CREATE INDEX nodes_conveyor_id_type ON public.nodes USING btree (conveyor_id, type);



CREATE INDEX nodes_conveyor_id_version ON public.nodes USING btree (conveyor_id, version);



CREATE UNIQUE INDEX nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id ON public.nodes_transits USING btree (conveyor_id, to_conveyor_id, node_id, to_node_id);



CREATE INDEX tasks_archive_change_time ON public.tasks_archive USING btree (change_time);



CREATE INDEX tasks_archive_conveyor_id_node_id_change_time ON public.tasks_archive USING btree (conveyor_id, node_id, change_time) WHERE (node_id IS NOT NULL);



CREATE INDEX tasks_archive_conveyor_id_reference ON public.tasks_archive USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);



CREATE INDEX tasks_archive_conveyor_id_task_id ON public.tasks_archive USING btree (conveyor_id, task_id) WHERE (task_id IS NOT NULL);



CREATE INDEX tasks_conveyor_id_node_id_status ON public.tasks USING btree (conveyor_id, node_id, status);



CREATE UNIQUE INDEX tasks_conveyor_id_reference ON public.tasks USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);



CREATE INDEX tasks_history_conveyor_id_create_time ON public.tasks_history USING btree (conveyor_id, create_time);



CREATE INDEX tasks_history_conveyor_id_reference ON public.tasks_history USING btree (conveyor_id, reference);



CREATE INDEX tasks_history_conveyor_id_task_id_create_time ON public.tasks_history USING btree (conveyor_id, task_id, create_time);



CREATE INDEX tasks_node_id_change_time ON public.tasks USING btree (node_id, change_time);



CREATE INDEX tasks_node_id_change_time_desc ON public.tasks USING btree (node_id, change_time DESC);



CREATE INDEX tasks_node_id_dynamic_timer ON public.tasks USING btree (node_id, dynamic_timer);



