CREATE TYPE git_call_lang AS ENUM (
    'js',
    'py',
    'erl',
    'java'
);


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE git_call_src_temp (
    id integer NOT NULL,
    conv_id integer NOT NULL,
    node_id character varying(24) NOT NULL,
    src text,
    deps text DEFAULT '{}'::text,
    lang git_call_lang NOT NULL
);



CREATE SEQUENCE git_call_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE git_call_src_temp_id_seq OWNED BY git_call_src_temp.id;

CREATE TABLE "js-code-hub" (
    id uuid DEFAULT uuid_generate_v1() NOT NULL,
    owner character varying(200) NOT NULL,
    name character varying(200) NOT NULL,
    "commit-hash" character varying(200) NOT NULL,
    device character varying(200) NOT NULL,
    "build-command" character varying(200) NOT NULL
);

CREATE TABLE "js-code-hub-build" (
    id character varying(500) NOT NULL,
    "container-id" character varying(100) NOT NULL,
    "created-at" timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE "js-script" (
    id character varying(100) NOT NULL,
    version character varying(100) NOT NULL,
    source text,
    dependencies text
);

ALTER TABLE ONLY git_call_src_temp ALTER COLUMN id SET DEFAULT nextval('git_call_src_temp_id_seq'::regclass);

ALTER TABLE ONLY git_call_src_temp
    ADD CONSTRAINT git_call_src_temp_conv_id_node_id_key UNIQUE (conv_id, node_id);

ALTER TABLE ONLY git_call_src_temp
    ADD CONSTRAINT git_call_src_temp_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "js-code-hub-build"
    ADD CONSTRAINT "js-code-hub-build_id_key" UNIQUE (id);

ALTER TABLE ONLY "js-code-hub"
    ADD CONSTRAINT "js-code-hub_pkey" PRIMARY KEY (id);

ALTER TABLE ONLY "js-code-hub"
    ADD CONSTRAINT "unique-js-code-hub" UNIQUE (owner, name, "commit-hash", "build-command");

ALTER TABLE ONLY "js-script"
    ADD CONSTRAINT "unique-js-script" UNIQUE (id, version);
