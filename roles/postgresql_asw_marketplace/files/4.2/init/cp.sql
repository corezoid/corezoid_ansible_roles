CREATE TABLE charts (
    id character(24) NOT NULL,
    dashboard_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    settings text,
    series text,
    chart_type character varying(40) DEFAULT NULL::character varying
);

CREATE TABLE conveyor_params_access (
    id bigint NOT NULL,
    from_conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    ts integer NOT NULL,
    count integer NOT NULL,
    period integer NOT NULL
);

CREATE SEQUENCE conveyor_params_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE conveyor_params_access_id_seq OWNED BY conveyor_params_access.id;

CREATE TABLE node_commits_history (
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
    create_time integer
);

CREATE SEQUENCE node_commits_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE node_commits_history_id_seq OWNED BY node_commits_history.id;

CREATE TABLE nodes (
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
    type_temp smallint DEFAULT 1 NOT NULL,
    x_temp integer,
    y_temp integer,
    status_temp smallint DEFAULT 1 NOT NULL
);

ALTER TABLE nodes OWNER TO postgres;

CREATE TABLE nodes_transits (
    id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    to_conveyor_id integer NOT NULL,
    to_node_id character(24) NOT NULL,
    prioritet smallint,
    convert text,
    description character varying(255)
);

ALTER TABLE nodes_transits OWNER TO postgres;

CREATE SEQUENCE nodes_transits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE nodes_transits_id_seq OWNED BY nodes_transits.id;

CREATE TABLE register_stream_counters (
    id bigint NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    key character varying(100) NOT NULL,
    value numeric(50,5) NOT NULL,
    period integer NOT NULL
);

CREATE SEQUENCE register_stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE register_stream_counters_id_seq OWNED BY register_stream_counters.id;

CREATE TABLE stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);

CREATE SEQUENCE stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE stream_counters_id_seq OWNED BY stream_counters.id;

CREATE TABLE tasks (
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
    dynamic_timer integer DEFAULT 0 NOT NULL
);

CREATE TABLE tasks_archive (
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
    task_id character(24)
);

CREATE SEQUENCE tasks_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE tasks_archive_id_seq OWNED BY tasks_archive.id;

CREATE TABLE tasks_history (
    id bigint NOT NULL,
    task_id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    conveyor_prev_id integer,
    node_id character(24) NOT NULL,
    user_id integer,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    node_prev_id character(24),
    status integer DEFAULT 1 NOT NULL,
    data text,
    prev_id integer DEFAULT 0
);

CREATE SEQUENCE tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE tasks_history_id_seq OWNED BY tasks_history.id;

CREATE TABLE user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    type smallint NOT NULL,
    prioritet smallint
);

CREATE SEQUENCE user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;

ALTER TABLE ONLY conveyor_params_access ALTER COLUMN id SET DEFAULT nextval('conveyor_params_access_id_seq'::regclass);

ALTER TABLE ONLY node_commits_history ALTER COLUMN id SET DEFAULT nextval('node_commits_history_id_seq'::regclass);

ALTER TABLE ONLY nodes_transits ALTER COLUMN id SET DEFAULT nextval('nodes_transits_id_seq'::regclass);

ALTER TABLE ONLY register_stream_counters ALTER COLUMN id SET DEFAULT nextval('register_stream_counters_id_seq'::regclass);

ALTER TABLE ONLY stream_counters ALTER COLUMN id SET DEFAULT nextval('stream_counters_id_seq'::regclass);

ALTER TABLE ONLY tasks_archive ALTER COLUMN id SET DEFAULT nextval('tasks_archive_id_seq'::regclass);

ALTER TABLE ONLY tasks_history ALTER COLUMN id SET DEFAULT nextval('tasks_history_id_seq'::regclass);

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);


ALTER TABLE ONLY charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);

ALTER TABLE ONLY node_commits_history
    ADD CONSTRAINT node_commits_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY nodes_transits
    ADD CONSTRAINT nodes_transits_pkey PRIMARY KEY (id);

ALTER TABLE ONLY conveyor_params_access
    ADD CONSTRAINT pk_conveyor_params_access PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, user_id);

ALTER TABLE ONLY register_stream_counters
    ADD CONSTRAINT pk_register_stream_counters PRIMARY KEY (conveyor_id, node_id, ts, key);

ALTER TABLE ONLY stream_counters
    ADD CONSTRAINT pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);

ALTER TABLE ONLY tasks_archive
    ADD CONSTRAINT tasks_archive_pkey PRIMARY KEY (id);

ALTER TABLE ONLY tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);


CREATE INDEX charts_dashboard_id ON charts USING btree (dashboard_id);

CREATE INDEX charts_id_dashboard_id ON charts USING btree (id, dashboard_id);

CREATE INDEX conv_id_version_create_time ON node_commits_history USING btree (conveyor_id, version, create_time);

CREATE INDEX ix_conveyor_params_access_id ON conveyor_params_access USING btree (id);

CREATE INDEX ix_register_stream_counters_id ON register_stream_counters USING btree (id);

CREATE INDEX ix_stream_counters_id ON stream_counters USING btree (id);

CREATE INDEX nodes_conveyor_id ON nodes USING btree (conveyor_id);

CREATE INDEX nodes_conveyor_id_type ON nodes USING btree (conveyor_id, type);

CREATE UNIQUE INDEX nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id ON nodes_transits USING btree (conveyor_id, to_conveyor_id, node_id, to_node_id);

CREATE INDEX tasks_archive_change_time ON tasks_archive USING btree (change_time);

CREATE INDEX tasks_archive_conveyor_id_node_id_change_time ON tasks_archive USING btree (conveyor_id, node_id, change_time) WHERE (node_id IS NOT NULL);

CREATE INDEX tasks_archive_conveyor_id_reference ON tasks_archive USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);

CREATE INDEX tasks_archive_conveyor_id_task_id ON tasks_archive USING btree (conveyor_id, task_id) WHERE (task_id IS NOT NULL);

CREATE INDEX tasks_conveyor_id_node_id_status ON tasks USING btree (conveyor_id, node_id, status);

CREATE UNIQUE INDEX tasks_conveyor_id_reference ON tasks USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);

CREATE INDEX tasks_history_conveyor_id_create_time ON tasks_history USING btree (conveyor_id, create_time);

CREATE INDEX tasks_history_conveyor_id_reference ON tasks_history USING btree (conveyor_id, reference);

CREATE INDEX tasks_history_conveyor_id_task_id_create_time ON tasks_history USING btree (conveyor_id, task_id, create_time);

CREATE INDEX tasks_node_id_change_time ON tasks USING btree (node_id, change_time);

CREATE INDEX tasks_node_id_dynamic_timer ON tasks USING btree (node_id, dynamic_timer);
