

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

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.limits (
    id integer NOT NULL,
    tree_id integer NOT NULL,
    type smallint NOT NULL,
    value bigint,
    used bigint DEFAULT 0,
    updated_by_user boolean DEFAULT false NOT NULL
);



CREATE TABLE public.limits_history (
    id integer NOT NULL,
    tree_id integer NOT NULL,
    user_id integer,
    limits text,
    ts integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    force boolean DEFAULT false NOT NULL
);



CREATE SEQUENCE public.limits_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_history_id_seq OWNED BY public.limits_history.id;



CREATE SEQUENCE public.limits_history_tree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_history_tree_id_seq OWNED BY public.limits_history.tree_id;



CREATE SEQUENCE public.limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_id_seq OWNED BY public.limits.id;



CREATE SEQUENCE public.limits_tree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.limits_tree_id_seq OWNED BY public.limits.tree_id;



CREATE TABLE public.tree (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    obj_id character varying(255) DEFAULT '0'::character varying,
    obj_type smallint NOT NULL,
    company_id character varying(255) DEFAULT '0'::character varying
);



CREATE SEQUENCE public.tree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tree_id_seq OWNED BY public.tree.id;



CREATE SEQUENCE public.tree_parent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tree_parent_id_seq OWNED BY public.tree.parent_id;



ALTER TABLE ONLY public.limits ALTER COLUMN id SET DEFAULT nextval('public.limits_id_seq'::regclass);



ALTER TABLE ONLY public.limits ALTER COLUMN tree_id SET DEFAULT nextval('public.limits_tree_id_seq'::regclass);



ALTER TABLE ONLY public.limits_history ALTER COLUMN id SET DEFAULT nextval('public.limits_history_id_seq'::regclass);



ALTER TABLE ONLY public.limits_history ALTER COLUMN tree_id SET DEFAULT nextval('public.limits_history_tree_id_seq'::regclass);



ALTER TABLE ONLY public.tree ALTER COLUMN id SET DEFAULT nextval('public.tree_id_seq'::regclass);



ALTER TABLE ONLY public.tree ALTER COLUMN parent_id SET DEFAULT nextval('public.tree_parent_id_seq'::regclass);



ALTER TABLE ONLY public.limits_history
    ADD CONSTRAINT limits_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.limits
    ADD CONSTRAINT limits_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tree
    ADD CONSTRAINT tree_pkey PRIMARY KEY (id);



CREATE UNIQUE INDEX limits_tree_id_type ON public.limits USING btree (tree_id, type);



CREATE UNIQUE INDEX tree_obj_id_obj_type_company_id ON public.tree USING btree (obj_id, obj_type, company_id);



