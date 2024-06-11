

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.settings (
    key character varying(255) NOT NULL,
    value text,
    description text,
    is_required smallint DEFAULT 0,
    type smallint DEFAULT 0,
    vsn integer DEFAULT 0
);



CREATE TABLE public.settings_history (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    user_id integer,
    value text,
    ts integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    action smallint DEFAULT 0 NOT NULL,
    title character varying(1024),
    login character varying(255)
);



CREATE SEQUENCE public.settings_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.settings_history_id_seq OWNED BY public.settings_history.id;



ALTER TABLE ONLY public.settings_history ALTER COLUMN id SET DEFAULT nextval('public.settings_history_id_seq'::regclass);



ALTER TABLE ONLY public.settings_history
    ADD CONSTRAINT settings_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (key);



