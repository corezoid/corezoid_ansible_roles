CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE TYPE cce_src_lang AS ENUM (
    'erl',
    'js',
    'lua'
);

ALTER TYPE cce_src_lang OWNER TO postgres;

CREATE TABLE cce_src (
    conv text NOT NULL,
    node text NOT NULL,
    src text,
    lang cce_src_lang
);

CREATE TABLE cce_src_temp (
    id integer NOT NULL,
    conv text,
    node text,
    src text,
    lang cce_src_lang
);

CREATE SEQUENCE cce_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE cce_src_temp_id_seq OWNED BY cce_src_temp.id;


ALTER TABLE ONLY cce_src_temp ALTER COLUMN id SET DEFAULT nextval('cce_src_temp_id_seq'::regclass);

ALTER TABLE ONLY cce_src_temp
    ADD CONSTRAINT cce_src_temp_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cce_src
    ADD CONSTRAINT my_index PRIMARY KEY (conv, node);

CREATE UNIQUE INDEX conv_node_cce_src_temp ON cce_src_temp USING btree (conv, node);

