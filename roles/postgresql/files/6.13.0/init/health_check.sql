

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


CREATE TABLE public.events (
    id integer NOT NULL,
    title text NOT NULL,
    description text,
    status smallint DEFAULT 1,
    user_id integer NOT NULL,
    ts integer NOT NULL
);



CREATE TABLE public.events_history (
    id integer NOT NULL,
    event_id integer,
    status smallint DEFAULT 1,
    ts integer,
    user_id integer NOT NULL
);



CREATE SEQUENCE public.events_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.events_history_id_seq OWNED BY public.events_history.id;



CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;



CREATE TABLE public.service_problem_history (
    id integer NOT NULL,
    service_id integer,
    description text,
    status smallint DEFAULT 1,
    ts integer,
    user_id integer NOT NULL,
    resolved boolean DEFAULT false
);



CREATE SEQUENCE public.service_problem_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.service_problem_history_id_seq OWNED BY public.service_problem_history.id;



CREATE TABLE public.services (
    id integer NOT NULL,
    title text NOT NULL,
    short_name character(40) NOT NULL,
    description text,
    status integer DEFAULT 1,
    user_id integer NOT NULL
);



CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;



ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);



ALTER TABLE ONLY public.events_history ALTER COLUMN id SET DEFAULT nextval('public.events_history_id_seq'::regclass);



ALTER TABLE ONLY public.service_problem_history ALTER COLUMN id SET DEFAULT nextval('public.service_problem_history_id_seq'::regclass);



ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);



ALTER TABLE ONLY public.events_history
    ADD CONSTRAINT events_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.service_problem_history
    ADD CONSTRAINT service_problem_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_short_name_key UNIQUE (short_name);



CREATE INDEX sph_select_idx ON public.service_problem_history USING btree (service_id, status, resolved);



