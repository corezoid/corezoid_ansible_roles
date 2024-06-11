
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA pglogical;

ALTER SCHEMA pglogical OWNER TO postgres;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION IF NOT EXISTS pglogical WITH SCHEMA pglogical;

COMMENT ON EXTENSION pglogical IS 'PostgreSQL Logical Replication';


CREATE TYPE public.cce_src_lang AS ENUM (
    'erl',
    'js',
    'lua'
);


ALTER TYPE public.cce_src_lang OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.cce_src (
    conv text NOT NULL,
    node text NOT NULL,
    src text,
    lang public.cce_src_lang
);


ALTER TABLE public.cce_src OWNER TO postgres;

CREATE TABLE public.cce_src_temp (
    id integer NOT NULL,
    conv text,
    node text,
    src text,
    lang public.cce_src_lang
);


ALTER TABLE public.cce_src_temp OWNER TO postgres;

CREATE SEQUENCE public.cce_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cce_src_temp_id_seq OWNER TO postgres;

ALTER SEQUENCE public.cce_src_temp_id_seq OWNED BY public.cce_src_temp.id;

ALTER TABLE ONLY public.cce_src_temp ALTER COLUMN id SET DEFAULT nextval('public.cce_src_temp_id_seq'::regclass);

ALTER TABLE ONLY public.cce_src_temp
    ADD CONSTRAINT cce_src_temp_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.cce_src
    ADD CONSTRAINT my_index PRIMARY KEY (conv, node);

CREATE UNIQUE INDEX conv_node_cce_src_temp ON public.cce_src_temp USING btree (conv, node);

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


REVOKE ALL ON TABLE public.cce_src FROM PUBLIC;
REVOKE ALL ON TABLE public.cce_src FROM postgres;
GRANT ALL ON TABLE public.cce_src TO postgres;
GRANT ALL ON TABLE public.cce_src TO cce_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cce_src TO appusers;
GRANT SELECT ON TABLE public.cce_src TO viewers;



REVOKE ALL ON TABLE public.cce_src_temp FROM PUBLIC;
REVOKE ALL ON TABLE public.cce_src_temp FROM postgres;
GRANT ALL ON TABLE public.cce_src_temp TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cce_src_temp TO cce_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cce_src_temp TO appusers;
GRANT SELECT ON TABLE public.cce_src_temp TO viewers;


REVOKE ALL ON SEQUENCE public.cce_src_temp_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.cce_src_temp_id_seq FROM postgres;
GRANT ALL ON SEQUENCE public.cce_src_temp_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE public.cce_src_temp_id_seq TO cce_user;
GRANT SELECT,UPDATE ON SEQUENCE public.cce_src_temp_id_seq TO appusers;
GRANT SELECT ON SEQUENCE public.cce_src_temp_id_seq TO viewers;

