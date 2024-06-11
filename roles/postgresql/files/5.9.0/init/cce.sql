

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


CREATE TYPE public.cce_src_lang AS ENUM (
    'erl',
    'js',
    'lua'
);


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.cce_src (
    conv text NOT NULL,
    node text NOT NULL,
    src text,
    lang public.cce_src_lang
);



CREATE TABLE public.cce_src_temp (
    id integer NOT NULL,
    conv text,
    node text,
    src text,
    lang public.cce_src_lang
);



CREATE SEQUENCE public.cce_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.cce_src_temp_id_seq OWNED BY public.cce_src_temp.id;



ALTER TABLE ONLY public.cce_src_temp ALTER COLUMN id SET DEFAULT nextval('public.cce_src_temp_id_seq'::regclass);



ALTER TABLE ONLY public.cce_src_temp
    ADD CONSTRAINT cce_src_temp_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.cce_src
    ADD CONSTRAINT my_index PRIMARY KEY (conv, node);



CREATE UNIQUE INDEX conv_node_cce_src_temp ON public.cce_src_temp USING btree (conv, node);



