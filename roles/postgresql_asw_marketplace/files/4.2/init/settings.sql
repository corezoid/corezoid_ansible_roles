

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


CREATE TABLE public.components_versions (
    id integer NOT NULL,
    payload text NOT NULL,
    ts integer NOT NULL
);



CREATE SEQUENCE public.components_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.components_versions_id_seq OWNED BY public.components_versions.id;



CREATE TABLE public.settings (
    key character varying(255) NOT NULL,
    value text,
    description text,
    is_required smallint DEFAULT 0,
    type smallint DEFAULT 0,
    vsn integer DEFAULT 0,
    id integer NOT NULL
);



CREATE TABLE public.settings_history (
    id integer NOT NULL,
    user_id integer,
    value text,
    ts integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    action smallint DEFAULT 0 NOT NULL,
    title character varying(1024),
    login character varying(255),
    setting_id integer NOT NULL
);



CREATE SEQUENCE public.settings_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.settings_history_id_seq OWNED BY public.settings_history.id;



CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;



CREATE TABLE public.settings_tags_id (
    setting_id integer NOT NULL,
    tag_id integer NOT NULL
);



CREATE TABLE public.tags (
    id integer NOT NULL,
    tag text NOT NULL
);



CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;



ALTER TABLE ONLY public.components_versions ALTER COLUMN id SET DEFAULT nextval('public.components_versions_id_seq'::regclass);



ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);



ALTER TABLE ONLY public.settings_history ALTER COLUMN id SET DEFAULT nextval('public.settings_history_id_seq'::regclass);



ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);



ALTER TABLE ONLY public.components_versions
    ADD CONSTRAINT components_versions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.settings_history
    ADD CONSTRAINT settings_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_key_key UNIQUE (key);



ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.settings_tags_id
    ADD CONSTRAINT settings_tags_id_pkey PRIMARY KEY (setting_id, tag_id);



ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_key UNIQUE (tag);



ALTER TABLE ONLY public.components_versions
    ADD CONSTRAINT uniq UNIQUE (payload);



ALTER TABLE ONLY public.settings_tags_id
    ADD CONSTRAINT settings_tags_id_setting_id_fkey FOREIGN KEY (setting_id) REFERENCES public.settings(id);



ALTER TABLE ONLY public.settings_tags_id
    ADD CONSTRAINT settings_tags_id_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id);



