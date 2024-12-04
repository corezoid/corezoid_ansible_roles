

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



CREATE FUNCTION public.check_workspace_object_constraint(idin integer DEFAULT NULL::integer, typein integer DEFAULT NULL::integer, widin integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF idIn > 0 THEN
        RETURN( SELECT id
                FROM public.resources
                WHERE id = idIn and type  = typeIn
                  and (workspace_id = widIn or workspace_id is null));
    ELSE
        RETURN 1;
    END IF;
END; $$;


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.events (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    name character varying(100) NOT NULL,
    workspace_id character varying(100),
    data text NOT NULL,
    client_id integer NOT NULL
);



CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;



CREATE TABLE public.ext_tokens (
    login character varying(255) NOT NULL,
    type smallint NOT NULL,
    token text NOT NULL,
    created_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE public.group_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.invites (
    id integer NOT NULL,
    workspace_id integer,
    sys_workspace_type integer DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    sys_role_type integer DEFAULT 3 NOT NULL,
    login character varying(100),
    redirect_uri character varying(100),
    client_id integer,
    created_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE public.invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.invites_id_seq OWNED BY public.invites.id;



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
    scope text,
    subscribes text
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



CREATE TABLE public.oauth2_external_auth_data (
    user_id integer NOT NULL,
    auth_provider_id character varying(128) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    expire_at timestamp without time zone,
    auth_data text NOT NULL,
    refresh_token text
);



CREATE TABLE public.oauth2_external_auth_scopes (
    client_id character varying(255) NOT NULL,
    provider_id character varying(128) NOT NULL,
    scope character varying(128) NOT NULL
);



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



CREATE SEQUENCE public.perm_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.resources (
    id integer NOT NULL,
    type smallint NOT NULL,
    ext_id character varying(40),
    name character varying(255) NOT NULL,
    photo text,
    status smallint DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    workspace_id integer,
    attributes text,
    search_title tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (((((id)::text || ' '::text) || (COALESCE(ext_id, ''::character varying))::text) || ' '::text) || (name)::text))) STORED
);



CREATE SEQUENCE public.role_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.rules (
    workspace_id integer,
    subject_type smallint NOT NULL,
    subject_id integer NOT NULL,
    object_type smallint NOT NULL,
    object_id integer,
    relation smallint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT rules_check CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check1 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check10 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check100 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check101 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check102 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check103 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check104 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check105 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check106 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check107 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check108 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check109 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check11 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check110 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check111 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check112 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check113 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check114 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check115 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check116 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check117 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check118 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check119 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check12 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check120 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check121 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check122 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check123 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check124 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check125 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check126 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check127 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check128 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check129 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check13 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check130 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check131 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check14 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check15 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check16 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check17 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check18 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check19 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check2 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check20 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check21 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check22 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check23 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check24 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check25 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check26 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check27 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check28 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check29 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check3 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check30 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check31 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check32 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check33 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check34 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check35 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check36 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check37 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check38 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check39 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check4 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check40 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check41 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check42 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check43 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check44 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check45 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check46 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check47 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check48 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check49 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check5 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check50 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check51 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check52 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check53 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check54 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check55 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check56 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check57 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check58 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check59 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check6 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check60 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check61 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check62 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check63 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check64 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check65 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check66 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check67 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check68 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check69 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check7 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check70 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check71 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check72 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check73 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check74 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check75 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check76 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check77 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check78 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check79 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check8 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check80 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check81 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check82 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check83 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check84 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check85 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check86 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check87 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check88 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check89 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check9 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check90 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check91 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check92 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check93 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check94 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check95 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check96 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check97 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check98 CHECK ((public.check_workspace_object_constraint(object_id, (object_type)::integer, workspace_id) IS NOT NULL)),
    CONSTRAINT rules_check99 CHECK ((public.check_workspace_object_constraint(subject_id, (subject_type)::integer, workspace_id) IS NOT NULL))
);



CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);



CREATE SEQUENCE public.scope_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



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



CREATE TABLE public.user_apis (
    resource_id integer NOT NULL,
    url character varying(255) NOT NULL,
    owner_user_id integer DEFAULT 0 NOT NULL,
    secret character varying(255) NOT NULL,
    sys_api_user_type integer DEFAULT 5 NOT NULL
);



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
    ext_user_id integer,
    search_title tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (((id)::text || ' '::text) || (name)::text))) STORED
);



CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;



CREATE TABLE public.workers (
    hash character varying(255) NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE public.workspace_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);



ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);



ALTER TABLE ONLY public.logins ALTER COLUMN id SET DEFAULT nextval('public.logins_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_client_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_client_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_clients_to_groups ALTER COLUMN id SET DEFAULT nextval('public.oauth2_clients_to_groups_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_history ALTER COLUMN id SET DEFAULT nextval('public.oauth2_history_id_seq'::regclass);



ALTER TABLE ONLY public.oauth2_scopes ALTER COLUMN id SET DEFAULT nextval('public.oauth2_scopes_id_seq'::regclass);



ALTER TABLE ONLY public.single_account_api_keys ALTER COLUMN id SET DEFAULT nextval('public.single_account_api_keys_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.resources
    ADD CONSTRAINT ext_id_type_unique UNIQUE (ext_id, type);



ALTER TABLE ONLY public.ext_tokens
    ADD CONSTRAINT ext_tokens_type_login_key UNIQUE (type, login);



ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);



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



ALTER TABLE ONLY public.oauth2_external_auth_data
    ADD CONSTRAINT oauth2_external_auth_data_pkey PRIMARY KEY (user_id, auth_provider_id);



ALTER TABLE ONLY public.oauth2_external_auth_scopes
    ADD CONSTRAINT oauth2_external_auth_scopes_pkey PRIMARY KEY (client_id, provider_id, scope);



ALTER TABLE ONLY public.oauth2_history
    ADD CONSTRAINT oauth2_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_scopes
    ADD CONSTRAINT oauth2_scopes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (refresh_token);



ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_user_id_client_id_key UNIQUE (user_id, client_id);



ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_id_type_key UNIQUE (id, type);



ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);



ALTER TABLE ONLY public.single_account_api_keys
    ADD CONSTRAINT single_account_api_keys_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_to_2fa
    ADD CONSTRAINT user_to_2fa_pkey PRIMARY KEY (user_id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_hash_key UNIQUE (hash);



CREATE INDEX client_id_idx ON public.oauth2_scopes USING btree (client_id);



CREATE INDEX logins_login_idx ON public.logins USING gin (to_tsvector('english'::regconfig, (login)::text));



CREATE UNIQUE INDEX logins_login_type ON public.logins USING btree (login, type);



CREATE UNIQUE INDEX resources_ext_id_uniq ON public.resources USING btree (ext_id, type) WHERE (ext_id IS NOT NULL);



CREATE UNIQUE INDEX resources_id_type_uniq ON public.resources USING btree (id, type);



CREATE INDEX resources_search_title_idx ON public.resources USING gin (search_title);



CREATE UNIQUE INDEX resources_workspace_login_index ON public.invites USING btree (workspace_id, login);



CREATE UNIQUE INDEX rules_not_null_uni_idx ON public.rules USING btree (workspace_id, subject_type, subject_id, object_type, object_id, relation) WHERE (workspace_id IS NOT NULL);



CREATE UNIQUE INDEX rules_null_uni_idx ON public.rules USING btree (subject_type, subject_id, object_type, object_id, relation) WHERE (workspace_id IS NULL);



CREATE UNIQUE INDEX u_idx_client_id_name_scopes ON public.oauth2_scopes USING btree (client_id, name);



CREATE UNIQUE INDEX user_apis_secret_x ON public.user_apis USING btree (secret);



CREATE INDEX users_search_title_idx ON public.users USING gin (search_title);



ALTER TABLE ONLY public.invites
    ADD CONSTRAINT client_id FOREIGN KEY (client_id) REFERENCES public.oauth2_clients(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.events
    ADD CONSTRAINT client_id FOREIGN KEY (client_id) REFERENCES public.oauth2_clients(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.oauth2_external_auth_scopes
    ADD CONSTRAINT oauth2_external_auth_scopes_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.oauth2_clients(client_id) ON DELETE CASCADE;



ALTER TABLE ONLY public.invites
    ADD CONSTRAINT role_id FOREIGN KEY (role_id, sys_role_type) REFERENCES public.resources(id, type) ON DELETE CASCADE;



ALTER TABLE ONLY public.rules
    ADD CONSTRAINT rules_object_key FOREIGN KEY (object_id, object_type) REFERENCES public.resources(id, type) ON DELETE CASCADE;



ALTER TABLE ONLY public.rules
    ADD CONSTRAINT rules_subject_key FOREIGN KEY (subject_id, subject_type) REFERENCES public.resources(id, type) ON DELETE CASCADE;



ALTER TABLE ONLY public.user_apis
    ADD CONSTRAINT user_apis_owner_user_id FOREIGN KEY (owner_user_id) REFERENCES public.users(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.user_apis
    ADD CONSTRAINT user_apis_resource_id_type FOREIGN KEY (resource_id, sys_api_user_type) REFERENCES public.resources(id, type) ON DELETE CASCADE;



ALTER TABLE ONLY public.invites
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.invites
    ADD CONSTRAINT workspace_id FOREIGN KEY (workspace_id, sys_workspace_type) REFERENCES public.resources(id, type) ON DELETE CASCADE;



