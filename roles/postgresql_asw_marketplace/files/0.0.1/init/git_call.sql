

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE TYPE public.git_call_lang AS ENUM (
    'js',
    'py',
    'erl',
    'java'
);



CREATE DOMAIN public.node_id AS character varying(100) NOT NULL;



CREATE TYPE public.package_status AS ENUM (
    'new',
    'error',
    'installed',
    'to-remove'
);



CREATE DOMAIN public.user_id AS character varying(100) NOT NULL;



CREATE FUNCTION public.removepackagefornode(dependencyid uuid, nodeid public.node_id) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    amountOfRemovedItems integer;
    amountOfNodesThatUseDependency integer;
    amountOfRemovedDependencies integer;
BEGIN
    LOCK TABLE "js-code-hub";
    LOCK TABLE "js-code-hub-dep-node";

    WITH deleted AS (DELETE FROM "js-code-hub-dep-node" WHERE "dep-id" = dependencyId AND "node-id" = nodeID RETURNING *) SELECT count(*) FROM deleted INTO amountOfRemovedItems;

    IF amountOfRemovedItems = 0 THEN
        RETURN FALSE;
    END IF;

    IF amountOfRemovedItems > 1 THEN
        RAISE EXCEPTION 'Cannot have more than one entry of that pair, program error';
    END IF;

    SELECT COUNT(*) FROM "js-code-hub-dep-node" WHERE "dep-id" = dependencyId INTO amountOfNodesThatUseDependency;

    IF amountOfNodesThatUseDependency = 0 THEN
        WITH deleted AS (
           DELETE FROM "js-code-hub" WHERE id = dependencyId AND status NOT IN ('new') RETURNING *
        ) SELECT count(*) FROM deleted INTO amountOfRemovedDependencies;

        IF amountOfRemovedDependencies > 1 THEN
            RAISE EXCEPTION 'Cannot have more than one entry of dependency, program error';
        ELSIF amountOfRemovedDependencies = 1 THEN
            RETURN TRUE;
        END IF;
    END IF;

    RETURN FALSE;
END
$$;


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.compiled_deps (
    conv_id integer NOT NULL,
    node_id character varying(24) NOT NULL,
    dep_id character varying(36) NOT NULL,
    id integer NOT NULL
);



CREATE SEQUENCE public.compiled_deps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.compiled_deps_id_seq OWNED BY public.compiled_deps.id;



CREATE TABLE public.git_call_src_temp (
    id integer NOT NULL,
    conv_id integer NOT NULL,
    node_id character varying(24) NOT NULL,
    src text,
    deps text DEFAULT '{}'::text,
    lang public.git_call_lang NOT NULL
);



CREATE SEQUENCE public.git_call_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.git_call_src_temp_id_seq OWNED BY public.git_call_src_temp.id;



CREATE TABLE public."js-code-hub" (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    owner character varying(200) NOT NULL,
    name character varying(200) NOT NULL,
    "commit-hash" character varying(200) NOT NULL,
    device character varying(200) NOT NULL,
    "build-command" character varying(200) NOT NULL,
    "random-part" character varying(32) DEFAULT md5((random())::text),
    status public.package_status DEFAULT 'new'::public.package_status,
    "user-id" character varying(100) DEFAULT NULL::character varying
);



CREATE TABLE public."js-code-hub-build" (
    id character varying(500) NOT NULL,
    "container-id" character varying(100) NOT NULL,
    "created-at" timestamp with time zone DEFAULT now() NOT NULL
);



CREATE TABLE public."js-code-hub-dep-node" (
    "dep-id" uuid NOT NULL,
    "node-id" public.node_id,
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL
);



CREATE TABLE public."js-script" (
    id character varying(100) NOT NULL,
    version character varying(100) NOT NULL,
    source text,
    dependencies text
);



ALTER TABLE ONLY public.compiled_deps ALTER COLUMN id SET DEFAULT nextval('public.compiled_deps_id_seq'::regclass);



ALTER TABLE ONLY public.git_call_src_temp ALTER COLUMN id SET DEFAULT nextval('public.git_call_src_temp_id_seq'::regclass);



ALTER TABLE ONLY public.compiled_deps
    ADD CONSTRAINT compiled_deps_conv_id_node_id_dep_id_key UNIQUE (conv_id, node_id, dep_id);



ALTER TABLE ONLY public.compiled_deps
    ADD CONSTRAINT compiled_deps_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.git_call_src_temp
    ADD CONSTRAINT git_call_src_temp_conv_id_node_id_key UNIQUE (conv_id, node_id);



ALTER TABLE ONLY public.git_call_src_temp
    ADD CONSTRAINT git_call_src_temp_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public."js-code-hub-build"
    ADD CONSTRAINT "js-code-hub-build-id-pk" PRIMARY KEY (id);



ALTER TABLE ONLY public."js-code-hub-build"
    ADD CONSTRAINT "js-code-hub-build_id_key" UNIQUE (id);



ALTER TABLE ONLY public."js-code-hub-dep-node"
    ADD CONSTRAINT "js-code-hub-dep-node_pkey" PRIMARY KEY (id);



ALTER TABLE ONLY public."js-code-hub"
    ADD CONSTRAINT "js-code-hub_pkey" PRIMARY KEY (id);



ALTER TABLE ONLY public."js-script"
    ADD CONSTRAINT "js-script-id-pk" PRIMARY KEY (id);



ALTER TABLE ONLY public."js-code-hub"
    ADD CONSTRAINT "unique-js-code-hub" UNIQUE ("user-id", owner, name, "commit-hash", "build-command");



ALTER TABLE ONLY public."js-code-hub-dep-node"
    ADD CONSTRAINT "unique-js-code-hub-dep-node" UNIQUE ("dep-id", "node-id");



ALTER TABLE ONLY public."js-script"
    ADD CONSTRAINT "unique-js-script" UNIQUE (id, version);



