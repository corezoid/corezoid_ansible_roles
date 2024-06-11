

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


CREATE TABLE public.login_to_users (
    user_id integer NOT NULL,
    login_id integer NOT NULL
);



CREATE TABLE public.logins (
    id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    login character varying(100) NOT NULL,
    type smallint NOT NULL,
    hash1 character varying(255),
    hash2 character varying(255),
    hash1_change_time integer,
    hash1_change_time_last_expire_notification integer
);



CREATE SEQUENCE public.logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.logins_id_seq OWNED BY public.logins.id;



CREATE TABLE public.oauth2_access (
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    scope text
);



CREATE TABLE public.oauth2_client_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    privs text,
    description text,
    status integer DEFAULT 0
);



CREATE SEQUENCE public.oauth2_client_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_client_groups_id_seq OWNED BY public.oauth2_client_groups.id;



CREATE TABLE public.oauth2_clients (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    logo character varying(1024),
    homepage character varying(1024),
    client_id character varying(255) NOT NULL,
    client_secret character varying(255) NOT NULL,
    redirect_uri character varying(1024) NOT NULL,
    notify_url character varying(1024),
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    full_name character varying(255),
    scope text
);



CREATE SEQUENCE public.oauth2_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_clients_id_seq OWNED BY public.oauth2_clients.id;



CREATE TABLE public.oauth2_clients_to_groups (
    id integer NOT NULL,
    client_id integer NOT NULL,
    group_id integer NOT NULL
);



CREATE SEQUENCE public.oauth2_clients_to_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_clients_to_groups_id_seq OWNED BY public.oauth2_clients_to_groups.id;



CREATE TABLE public.oauth2_history (
    id integer NOT NULL,
    client_id integer NOT NULL,
    event_type character varying(255) NOT NULL,
    data text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL
);



CREATE SEQUENCE public.oauth2_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_history_id_seq OWNED BY public.oauth2_history.id;



CREATE TABLE public.oauth2_scopes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    client_id integer
);



CREATE SEQUENCE public.oauth2_scopes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.oauth2_scopes_id_seq OWNED BY public.oauth2_scopes.id;



CREATE TABLE public.oauth2_tokens (
    refresh_token character varying(255) NOT NULL,
    access_token character varying(255) NOT NULL,
    refresh_token_create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    access_token_create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    scope text,
    type smallint DEFAULT 0 NOT NULL
);



CREATE TABLE public.single_account_api_keys (
    id integer NOT NULL,
    client_id character varying(255) NOT NULL,
    scope text,
    api_user_id integer NOT NULL,
    api_login text NOT NULL,
    api_login_id integer NOT NULL
);



CREATE SEQUENCE public.single_account_api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.single_account_api_keys_id_seq OWNED BY public.single_account_api_keys.id;



CREATE TABLE public.user_to_2fa (
    user_id integer NOT NULL,
    type smallint DEFAULT 0,
    password character varying(32)
);



CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    status boolean DEFAULT true NOT NULL,
    data text,
    last_entrance integer DEFAULT (date_part('epoch'::text, now()))::integer,
    lang character varying(2),
    blocked_reason character varying(2000) DEFAULT NULL::character varying,
    ext_user_id integer
);



CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;



ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_client_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_client_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients_to_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_to_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_history ALTER COLUMN id SET DEFAULT nextval('public.oauth2_history_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_scopes ALTER COLUMN id SET DEFAULT nextval('public.oauth2_scopes_id_seq'::regclass);



ALTER TABLE ONLY public.single_account_api_keys ALTER COLUMN id SET DEFAULT nextval('public.single_account_api_keys_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



ALTER TABLE ONLY public.login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);



ALTER TABLE ONLY public.logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_access
    ADD CONSTRAINT oauth2_access_pkey PRIMARY KEY (user_id, client_id);



ALTER TABLE ONLY public.oauth2_client_groups
    ADD CONSTRAINT oauth2_client_groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_client_id_key UNIQUE (client_id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_client_id_group_id_key UNIQUE (client_id, group_id);



ALTER TABLE ONLY public.oauth2_clients_to_groups
    ADD CONSTRAINT oauth2_clients_to_groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_clients
    ADD CONSTRAINT oauth2_clients_unique_name UNIQUE (name);



ALTER TABLE ONLY public.oauth2_history
    ADD CONSTRAINT oauth2_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_scopes
    ADD CONSTRAINT oauth2_scopes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (refresh_token);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_user_id_client_id_key UNIQUE (user_id, client_id);



ALTER TABLE ONLY public.single_account_api_keys
    ADD CONSTRAINT single_account_api_keys_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_to_2fa
    ADD CONSTRAINT user_to_2fa_pkey PRIMARY KEY (user_id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



CREATE INDEX client_id_idx ON public.oauth2_scopes USING btree (client_id);



CREATE UNIQUE INDEX logins_login_type ON public.logins USING btree (login, type);



CREATE UNIQUE INDEX u_idx_client_id_name_scopes ON public.oauth2_scopes USING btree (client_id, name);



