--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE appusers;
ALTER ROLE appusers WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE dn031083daj;
ALTER ROLE dn031083daj WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE dn080180van;
ALTER ROLE dn080180van WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE internal_user;
ALTER ROLE internal_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5f7ee905c628cba12132be59cc7a36b7b';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;


--
-- Role memberships
--

GRANT appusers TO internal_user GRANTED BY postgres;
GRANT postgres TO dn031083daj GRANTED BY postgres;




--
-- Database creation
--

CREATE DATABASE cce WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE conveyor WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE cp0 WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE cp1 WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect cce

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: cce_src_lang; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE cce_src_lang AS ENUM (
    'erl',
    'js',
    'lua'
);


ALTER TYPE cce_src_lang OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cce_src; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cce_src (
    conv text,
    node text,
    src text,
    lang cce_src_lang
);


ALTER TABLE cce_src OWNER TO postgres;

--
-- Name: cce_src_temp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cce_src_temp (
    id integer NOT NULL,
    conv text,
    node text,
    src text,
    lang cce_src_lang
);


ALTER TABLE cce_src_temp OWNER TO postgres;

--
-- Name: cce_src_temp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cce_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cce_src_temp_id_seq OWNER TO postgres;

--
-- Name: cce_src_temp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cce_src_temp_id_seq OWNED BY cce_src_temp.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cce_src_temp ALTER COLUMN id SET DEFAULT nextval('cce_src_temp_id_seq'::regclass);


--
-- Name: cce_src_temp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cce_src_temp
    ADD CONSTRAINT cce_src_temp_pkey PRIMARY KEY (id);


--
-- Name: conv_node_cce_src_temp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX conv_node_cce_src_temp ON cce_src_temp USING btree (conv, node);


--
-- Name: my_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX my_index ON cce_src USING btree (conv, node);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: cce_src; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cce_src FROM PUBLIC;
REVOKE ALL ON TABLE cce_src FROM postgres;
GRANT ALL ON TABLE cce_src TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cce_src TO appusers;


--
-- Name: cce_src_temp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cce_src_temp FROM PUBLIC;
REVOKE ALL ON TABLE cce_src_temp FROM postgres;
GRANT ALL ON TABLE cce_src_temp TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cce_src_temp TO appusers;


--
-- Name: cce_src_temp_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE cce_src_temp_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cce_src_temp_id_seq FROM postgres;
GRANT ALL ON SEQUENCE cce_src_temp_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE cce_src_temp_id_seq TO appusers;


--
-- PostgreSQL database dump complete
--

\connect conveyor

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_callbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE api_callbacks (
    conveyor_id integer NOT NULL,
    hash character(40) NOT NULL,
    data text
);


ALTER TABLE api_callbacks OWNER TO postgres;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    owner_user_id integer NOT NULL,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    server_id integer,
    company_id character varying(25) NOT NULL
);


ALTER TABLE companies OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: conveyor_billing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_billing (
    conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    ts integer NOT NULL,
    opers_count integer NOT NULL,
    tacts_count integer NOT NULL,
    tasks_bytes_size bigint NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE conveyor_billing OWNER TO postgres;

--
-- Name: conveyor_billing_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_billing_old (
    conveyor_id integer,
    user_id integer,
    ts integer,
    opers_count integer,
    tacts_count integer,
    tasks_bytes_size bigint,
    period integer,
    id bigint
)
INHERITS (conveyor_billing);


ALTER TABLE conveyor_billing_old OWNER TO postgres;

--
-- Name: conveyor_billing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conveyor_billing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conveyor_billing_id_seq OWNER TO postgres;

--
-- Name: conveyor_billing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyor_billing_id_seq OWNED BY conveyor_billing_old.id;


--
-- Name: conveyor_to_shard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_to_shard (
    conveyor_id integer NOT NULL,
    shard character varying(255) NOT NULL
);


ALTER TABLE conveyor_to_shard OWNER TO postgres;

--
-- Name: conveyors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    status smallint DEFAULT 1,
    params text,
    owner_id integer,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    conv_type smallint,
    company_id character varying(25)
);


ALTER TABLE conveyors OWNER TO postgres;

--
-- Name: conveyors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conveyors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conveyors_id_seq OWNER TO postgres;

--
-- Name: conveyors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyors_id_seq OWNED BY conveyors.id;


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE dashboards (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_id integer NOT NULL,
    data text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25),
    charts_order text
);


ALTER TABLE dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dashboards_id_seq OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dashboards_id_seq OWNED BY dashboards.id;


--
-- Name: esc_conv_to_convs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE esc_conv_to_convs (
    esc_conv integer NOT NULL,
    conv integer NOT NULL
);


ALTER TABLE esc_conv_to_convs OWNER TO postgres;

--
-- Name: folder_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE folder_content (
    folder_id integer NOT NULL,
    obj_type integer NOT NULL,
    obj_id integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE folder_content OWNER TO postgres;

--
-- Name: folder_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE folder_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE folder_content_id_seq OWNER TO postgres;

--
-- Name: folder_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folder_content_id_seq OWNED BY folder_content.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE folders (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    owner_id integer NOT NULL,
    type smallint DEFAULT 0,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25)
);


ALTER TABLE folders OWNER TO postgres;

--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE folders_id_seq OWNER TO postgres;

--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folders_id_seq OWNED BY folders.id;


--
-- Name: group_to_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE group_to_group (
    parent_group_id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL
);


ALTER TABLE group_to_group OWNER TO postgres;

--
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE history (
    obj_id integer NOT NULL,
    obj_type smallint NOT NULL,
    user_id integer NOT NULL,
    change_time integer NOT NULL,
    title text,
    action_type smallint,
    id bigint NOT NULL
);


ALTER TABLE history OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE history_id_seq OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE history_id_seq OWNED BY history.id;


--
-- Name: login_to_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE login_to_users (
    user_id integer NOT NULL,
    login_id integer NOT NULL
);


ALTER TABLE login_to_users OWNER TO postgres;

--
-- Name: logins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE logins (
    id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    login character varying(100) NOT NULL,
    type smallint NOT NULL,
    hash1 character varying(255),
    hash2 character varying(255)
);


ALTER TABLE logins OWNER TO postgres;

--
-- Name: logins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logins_id_seq OWNER TO postgres;

--
-- Name: logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logins_id_seq OWNED BY logins.id;


--
-- Name: payment_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payment_plans (
    id integer NOT NULL,
    name character(255) NOT NULL,
    amount integer NOT NULL,
    tacts bigint NOT NULL
);


ALTER TABLE payment_plans OWNER TO postgres;

--
-- Name: payment_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payment_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment_plans_id_seq OWNER TO postgres;

--
-- Name: payment_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payment_plans_id_seq OWNED BY payment_plans.id;


--
-- Name: payments_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payments_history (
    order_id character varying(255) NOT NULL,
    payplan_id integer NOT NULL,
    paytype smallint DEFAULT 0,
    date_start character varying(255) DEFAULT date_part('epoch'::text, now()),
    amount integer NOT NULL,
    tacts integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    state smallint DEFAULT 1,
    payment_id character varying(255)
);


ALTER TABLE payments_history OWNER TO postgres;

--
-- Name: user_billing_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_billing_stats (
    user_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    conveyor_tacts bigint,
    "timestamp" integer,
    "interval" integer,
    operations bigint DEFAULT 0
);


ALTER TABLE user_billing_stats OWNER TO postgres;

--
-- Name: user_billing_tacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_billing_tacts (
    user_id integer NOT NULL,
    tacts bigint NOT NULL,
    "timestamp" integer NOT NULL,
    "interval" integer NOT NULL,
    operations bigint DEFAULT 0
);


ALTER TABLE user_billing_tacts OWNER TO postgres;

--
-- Name: user_dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_dashboards (
    dashboard_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);


ALTER TABLE user_dashboards OWNER TO postgres;

--
-- Name: user_folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_folders (
    folder_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text
);


ALTER TABLE user_folders OWNER TO postgres;

--
-- Name: user_group_privilegies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24),
    prioritet smallint,
    privs text
);


ALTER TABLE user_group_privilegies OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_group_privilegies_id_seq OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    status smallint DEFAULT 1,
    company_id character varying(25)
);


ALTER TABLE user_groups OWNER TO postgres;

--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_groups_id_seq OWNER TO postgres;

--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_editor_user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer
);


ALTER TABLE user_roles OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_roles_id_seq OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: user_to_companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_to_companies (
    id integer NOT NULL,
    company_id character varying(25) NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE user_to_companies OWNER TO postgres;

--
-- Name: user_to_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_to_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_to_companies_id_seq OWNER TO postgres;

--
-- Name: user_to_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_to_companies_id_seq OWNED BY user_to_companies.id;


--
-- Name: user_to_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_to_user_groups (
    user_group_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE user_to_user_groups OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    status boolean DEFAULT true NOT NULL,
    data text,
    last_entrance integer DEFAULT (date_part('epoch'::text, now()))::integer,
    lang character varying(2)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: web_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE web_settings (
    key character(50) NOT NULL,
    value text
);


ALTER TABLE web_settings OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing ALTER COLUMN id SET DEFAULT nextval('conveyor_billing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing_old ALTER COLUMN id SET DEFAULT nextval('conveyor_billing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyors ALTER COLUMN id SET DEFAULT nextval('conveyors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dashboards ALTER COLUMN id SET DEFAULT nextval('dashboards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folder_content ALTER COLUMN id SET DEFAULT nextval('folder_content_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folders ALTER COLUMN id SET DEFAULT nextval('folders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logins ALTER COLUMN id SET DEFAULT nextval('logins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_plans ALTER COLUMN id SET DEFAULT nextval('payment_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_companies ALTER COLUMN id SET DEFAULT nextval('user_to_companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: api_callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY api_callbacks
    ADD CONSTRAINT api_callbacks_pkey PRIMARY KEY (conveyor_id);


--
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: conveyor_billing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing_old
    ADD CONSTRAINT conveyor_billing_pkey PRIMARY KEY (id);


--
-- Name: conveyor_to_shard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_to_shard
    ADD CONSTRAINT conveyor_to_shard_pkey PRIMARY KEY (conveyor_id, shard);


--
-- Name: conveyors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyors
    ADD CONSTRAINT conveyors_pkey PRIMARY KEY (id);


--
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: folder_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folder_content
    ADD CONSTRAINT folder_content_pkey PRIMARY KEY (id);


--
-- Name: folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: group_to_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_to_group
    ADD CONSTRAINT group_to_group_pkey PRIMARY KEY (parent_group_id, group_id, conveyor_id);


--
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: login_to_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);


--
-- Name: logins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);


--
-- Name: pk_conveyor_billing; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing
    ADD CONSTRAINT pk_conveyor_billing PRIMARY KEY (conveyor_id, user_id, ts);


--
-- Name: user_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_dashboards
    ADD CONSTRAINT user_dashboards_pkey PRIMARY KEY (group_id, dashboard_id, level);


--
-- Name: user_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_folders
    ADD CONSTRAINT user_folders_pkey PRIMARY KEY (group_id, folder_id, level);


--
-- Name: user_group_privilegies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);


--
-- Name: user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_to_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_companies
    ADD CONSTRAINT user_to_companies_pkey PRIMARY KEY (company_id, user_id);


--
-- Name: user_to_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_user_groups
    ADD CONSTRAINT user_to_user_groups_pkey PRIMARY KEY (user_group_id, user_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: web_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (key);


--
-- Name: api_callbacks_hash_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX api_callbacks_hash_id ON api_callbacks USING btree (hash);


--
-- Name: companies_company_id_owner_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX companies_company_id_owner_user_id ON companies USING btree (id, owner_user_id);


--
-- Name: conveyor_billing_conveyor_id_user_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyor_billing_conveyor_id_user_id_ts ON conveyor_billing_old USING btree (conveyor_id, user_id, ts);


--
-- Name: conveyor_billing_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyor_billing_ts ON conveyor_billing_old USING btree (ts);


--
-- Name: conveyor_billing_user_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyor_billing_user_id_ts ON conveyor_billing_old USING btree (user_id, ts);


--
-- Name: conveyors_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyors_name ON conveyors USING btree (lower((name)::text) varchar_pattern_ops);


--
-- Name: esc_conv_to_convs_esc_conv_conv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX esc_conv_to_convs_esc_conv_conv ON esc_conv_to_convs USING btree (esc_conv, conv);


--
-- Name: folder_content_folder_id_obj_type_obj_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX folder_content_folder_id_obj_type_obj_id ON folder_content USING btree (folder_id, obj_type, obj_id);


--
-- Name: history_obj_id_obj_type_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX history_obj_id_obj_type_change_time ON history USING btree (obj_id, obj_type, change_time);


--
-- Name: ix_conveyor_billing_conveyor_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON conveyor_billing USING btree (conveyor_id, ts);


--
-- Name: ix_conveyor_billing_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_id ON conveyor_billing USING btree (id);


--
-- Name: ix_conveyor_billing_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_ts ON conveyor_billing USING btree (ts);


--
-- Name: ix_conveyor_billing_user_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_user_id_ts ON conveyor_billing USING btree (user_id, ts);


--
-- Name: logins_login_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX logins_login_type ON logins USING btree (login, type);


--
-- Name: payment_history_order_by_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_history_order_by_user ON payments_history USING btree (user_id, order_id);


--
-- Name: payment_history_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_history_order_id ON payments_history USING btree (order_id);


--
-- Name: user_billing_stats_user_to_conv_on_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON user_billing_stats USING btree (user_id, conveyor_id, "timestamp");


--
-- Name: user_billing_tacts_user_to_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_billing_tacts_user_to_timestamp ON user_billing_stats USING btree (user_id, "timestamp");


--
-- Name: user_group_privilegies_group_id_conveyor_id_node_id_prioritet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_privilegies_group_id_conveyor_id_node_id_prioritet ON user_group_privilegies USING btree (group_id, conveyor_id, node_id, prioritet) WHERE (node_id IS NOT NULL);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: api_callbacks; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE api_callbacks FROM PUBLIC;
REVOKE ALL ON TABLE api_callbacks FROM postgres;
GRANT ALL ON TABLE api_callbacks TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE api_callbacks TO appusers;


--
-- Name: companies; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE companies FROM PUBLIC;
REVOKE ALL ON TABLE companies FROM postgres;
GRANT ALL ON TABLE companies TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE companies TO appusers;


--
-- Name: companies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE companies_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE companies_id_seq FROM postgres;
GRANT ALL ON SEQUENCE companies_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE companies_id_seq TO appusers;


--
-- Name: conveyor_billing; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_billing FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_billing FROM postgres;
GRANT ALL ON TABLE conveyor_billing TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_billing TO appusers;


--
-- Name: conveyor_billing_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_billing_old FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_billing_old FROM postgres;
GRANT ALL ON TABLE conveyor_billing_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_billing_old TO appusers;


--
-- Name: conveyor_billing_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE conveyor_billing_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE conveyor_billing_id_seq FROM postgres;
GRANT ALL ON SEQUENCE conveyor_billing_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE conveyor_billing_id_seq TO appusers;


--
-- Name: conveyor_to_shard; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_to_shard FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_to_shard FROM postgres;
GRANT ALL ON TABLE conveyor_to_shard TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_to_shard TO appusers;


--
-- Name: conveyors; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyors FROM PUBLIC;
REVOKE ALL ON TABLE conveyors FROM postgres;
GRANT ALL ON TABLE conveyors TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyors TO appusers;


--
-- Name: conveyors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE conveyors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE conveyors_id_seq FROM postgres;
GRANT ALL ON SEQUENCE conveyors_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE conveyors_id_seq TO appusers;


--
-- Name: dashboards; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE dashboards FROM PUBLIC;
REVOKE ALL ON TABLE dashboards FROM postgres;
GRANT ALL ON TABLE dashboards TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE dashboards TO appusers;


--
-- Name: dashboards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE dashboards_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dashboards_id_seq FROM postgres;
GRANT ALL ON SEQUENCE dashboards_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE dashboards_id_seq TO appusers;


--
-- Name: esc_conv_to_convs; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE esc_conv_to_convs FROM PUBLIC;
REVOKE ALL ON TABLE esc_conv_to_convs FROM postgres;
GRANT ALL ON TABLE esc_conv_to_convs TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE esc_conv_to_convs TO appusers;


--
-- Name: folder_content; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE folder_content FROM PUBLIC;
REVOKE ALL ON TABLE folder_content FROM postgres;
GRANT ALL ON TABLE folder_content TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE folder_content TO appusers;


--
-- Name: folder_content_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE folder_content_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE folder_content_id_seq FROM postgres;
GRANT ALL ON SEQUENCE folder_content_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE folder_content_id_seq TO appusers;


--
-- Name: folders; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE folders FROM PUBLIC;
REVOKE ALL ON TABLE folders FROM postgres;
GRANT ALL ON TABLE folders TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE folders TO appusers;


--
-- Name: folders_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE folders_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE folders_id_seq FROM postgres;
GRANT ALL ON SEQUENCE folders_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE folders_id_seq TO appusers;


--
-- Name: group_to_group; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE group_to_group FROM PUBLIC;
REVOKE ALL ON TABLE group_to_group FROM postgres;
GRANT ALL ON TABLE group_to_group TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE group_to_group TO appusers;


--
-- Name: history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE history FROM PUBLIC;
REVOKE ALL ON TABLE history FROM postgres;
GRANT ALL ON TABLE history TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE history TO appusers;


--
-- Name: history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE history_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE history_id_seq FROM postgres;
GRANT ALL ON SEQUENCE history_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE history_id_seq TO appusers;


--
-- Name: login_to_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE login_to_users FROM PUBLIC;
REVOKE ALL ON TABLE login_to_users FROM postgres;
GRANT ALL ON TABLE login_to_users TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE login_to_users TO appusers;


--
-- Name: logins; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE logins FROM PUBLIC;
REVOKE ALL ON TABLE logins FROM postgres;
GRANT ALL ON TABLE logins TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE logins TO appusers;


--
-- Name: logins_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE logins_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE logins_id_seq FROM postgres;
GRANT ALL ON SEQUENCE logins_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE logins_id_seq TO appusers;


--
-- Name: payment_plans; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE payment_plans FROM PUBLIC;
REVOKE ALL ON TABLE payment_plans FROM postgres;
GRANT ALL ON TABLE payment_plans TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE payment_plans TO appusers;


--
-- Name: payment_plans_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE payment_plans_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE payment_plans_id_seq FROM postgres;
GRANT ALL ON SEQUENCE payment_plans_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE payment_plans_id_seq TO appusers;


--
-- Name: payments_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE payments_history FROM PUBLIC;
REVOKE ALL ON TABLE payments_history FROM postgres;
GRANT ALL ON TABLE payments_history TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE payments_history TO appusers;


--
-- Name: user_billing_stats; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_billing_stats FROM PUBLIC;
REVOKE ALL ON TABLE user_billing_stats FROM postgres;
GRANT ALL ON TABLE user_billing_stats TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_billing_stats TO appusers;


--
-- Name: user_billing_tacts; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_billing_tacts FROM PUBLIC;
REVOKE ALL ON TABLE user_billing_tacts FROM postgres;
GRANT ALL ON TABLE user_billing_tacts TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_billing_tacts TO appusers;


--
-- Name: user_dashboards; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_dashboards FROM PUBLIC;
REVOKE ALL ON TABLE user_dashboards FROM postgres;
GRANT ALL ON TABLE user_dashboards TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_dashboards TO appusers;


--
-- Name: user_folders; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_folders FROM PUBLIC;
REVOKE ALL ON TABLE user_folders FROM postgres;
GRANT ALL ON TABLE user_folders TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_folders TO appusers;


--
-- Name: user_group_privilegies; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_group_privilegies FROM PUBLIC;
REVOKE ALL ON TABLE user_group_privilegies FROM postgres;
GRANT ALL ON TABLE user_group_privilegies TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_group_privilegies TO appusers;


--
-- Name: user_group_privilegies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_group_privilegies_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_group_privilegies_id_seq TO appusers;


--
-- Name: user_groups; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_groups FROM PUBLIC;
REVOKE ALL ON TABLE user_groups FROM postgres;
GRANT ALL ON TABLE user_groups TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_groups TO appusers;


--
-- Name: user_groups_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_groups_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_groups_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_groups_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_groups_id_seq TO appusers;


--
-- Name: user_roles; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_roles FROM PUBLIC;
REVOKE ALL ON TABLE user_roles FROM postgres;
GRANT ALL ON TABLE user_roles TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_roles TO appusers;


--
-- Name: user_roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_roles_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_roles_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_roles_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_roles_id_seq TO appusers;


--
-- Name: user_to_companies; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_to_companies FROM PUBLIC;
REVOKE ALL ON TABLE user_to_companies FROM postgres;
GRANT ALL ON TABLE user_to_companies TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_to_companies TO appusers;


--
-- Name: user_to_companies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_to_companies_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_to_companies_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_to_companies_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_to_companies_id_seq TO appusers;


--
-- Name: user_to_user_groups; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_to_user_groups FROM PUBLIC;
REVOKE ALL ON TABLE user_to_user_groups FROM postgres;
GRANT ALL ON TABLE user_to_user_groups TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_to_user_groups TO appusers;


--
-- Name: users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgres;
GRANT ALL ON TABLE users TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE users TO appusers;


--
-- Name: users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_id_seq FROM postgres;
GRANT ALL ON SEQUENCE users_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE users_id_seq TO appusers;


--
-- Name: web_settings; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE web_settings FROM PUBLIC;
REVOKE ALL ON TABLE web_settings FROM postgres;
GRANT ALL ON TABLE web_settings TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE web_settings TO appusers;


--
-- PostgreSQL database dump complete
--

\connect cp0

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_repack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_repack WITH SCHEMA public;


--
-- Name: EXTENSION pg_repack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_repack IS 'Reorganize tables in PostgreSQL databases with minimal locks';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: charts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE charts (
    id character(24) NOT NULL,
    dashboard_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    settings text,
    series text
);


ALTER TABLE charts OWNER TO postgres;

--
-- Name: conveyor_params_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_params_access (
    from_conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    ts integer NOT NULL,
    count integer NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE conveyor_params_access OWNER TO postgres;

--
-- Name: conveyor_params_access_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_params_access_old (
    from_conveyor_id integer,
    user_id integer,
    to_conveyor_id integer,
    ts integer,
    count integer,
    period integer,
    id bigint
)
INHERITS (conveyor_params_access);


ALTER TABLE conveyor_params_access_old OWNER TO postgres;

--
-- Name: conveyor_params_access_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conveyor_params_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conveyor_params_access_id_seq OWNER TO postgres;

--
-- Name: conveyor_params_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyor_params_access_id_seq OWNED BY conveyor_params_access_old.id;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nodes (
    id character(24) NOT NULL,
    conveyor_id integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    condition text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    max_count integer DEFAULT 0 NOT NULL,
    max_time integer DEFAULT 0 NOT NULL,
    status smallint NOT NULL,
    x integer,
    y integer,
    extra text,
    version integer,
    condition_temp text,
    last_editor integer,
    last_change_time integer,
    name_temp character varying(255),
    description_temp text,
    x_temp integer,
    y_temp integer,
    extra_temp text,
    status_temp smallint DEFAULT 1 NOT NULL,
    type_temp smallint DEFAULT 1 NOT NULL
);


ALTER TABLE nodes OWNER TO postgres;

--
-- Name: nodes_transits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nodes_transits (
    id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    to_conveyor_id integer NOT NULL,
    to_node_id character(24) NOT NULL,
    prioritet smallint,
    convert text,
    description character varying(255)
);


ALTER TABLE nodes_transits OWNER TO postgres;

--
-- Name: nodes_transits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nodes_transits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nodes_transits_id_seq OWNER TO postgres;

--
-- Name: nodes_transits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nodes_transits_id_seq OWNED BY nodes_transits.id;


--
-- Name: register_stream_counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE register_stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    key character varying(100) NOT NULL,
    value numeric(50,5) NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE register_stream_counters OWNER TO postgres;

--
-- Name: register_stream_counters_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE register_stream_counters_old (
    conveyor_id integer,
    node_id character(24),
    ts integer,
    key character varying(100),
    value numeric(50,5),
    period integer,
    id bigint
)
INHERITS (register_stream_counters);


ALTER TABLE register_stream_counters_old OWNER TO postgres;

--
-- Name: register_stream_counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE register_stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE register_stream_counters_id_seq OWNER TO postgres;

--
-- Name: register_stream_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE register_stream_counters_id_seq OWNED BY register_stream_counters_old.id;


--
-- Name: stream_counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE stream_counters OWNER TO postgres;

--
-- Name: stream_counters_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stream_counters_old (
    conveyor_id integer,
    node_id character(24),
    ts integer,
    in_count integer,
    out_count integer,
    period integer,
    id bigint
)
INHERITS (stream_counters);


ALTER TABLE stream_counters_old OWNER TO postgres;

--
-- Name: stream_counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stream_counters_id_seq OWNER TO postgres;

--
-- Name: stream_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stream_counters_id_seq OWNED BY stream_counters_old.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks (
    id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    dynamic_timer integer DEFAULT 0 NOT NULL
);


ALTER TABLE tasks OWNER TO postgres;

--
-- Name: tasks_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks_archive (
    id integer NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    task_id character(24)
);


ALTER TABLE tasks_archive OWNER TO postgres;

--
-- Name: tasks_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tasks_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tasks_archive_id_seq OWNER TO postgres;

--
-- Name: tasks_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tasks_archive_id_seq OWNED BY tasks_archive.id;


--
-- Name: tasks_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks_history (
    id integer NOT NULL,
    task_id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    conveyor_prev_id integer,
    node_id character(24) NOT NULL,
    user_id integer,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    node_prev_id character(24),
    status integer DEFAULT 1 NOT NULL,
    data text,
    prev_id integer DEFAULT 0
);


ALTER TABLE tasks_history OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tasks_history_id_seq OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tasks_history_id_seq OWNED BY tasks_history.id;


--
-- Name: user_group_privilegies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    type smallint NOT NULL,
    prioritet smallint
);


ALTER TABLE user_group_privilegies OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_group_privilegies_id_seq OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access ALTER COLUMN id SET DEFAULT nextval('conveyor_params_access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access_old ALTER COLUMN id SET DEFAULT nextval('conveyor_params_access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes_transits ALTER COLUMN id SET DEFAULT nextval('nodes_transits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters ALTER COLUMN id SET DEFAULT nextval('register_stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters_old ALTER COLUMN id SET DEFAULT nextval('register_stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters ALTER COLUMN id SET DEFAULT nextval('stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters_old ALTER COLUMN id SET DEFAULT nextval('stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_archive ALTER COLUMN id SET DEFAULT nextval('tasks_archive_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_history ALTER COLUMN id SET DEFAULT nextval('tasks_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);


--
-- Name: charts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);


--
-- Name: conveyor_params_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access_old
    ADD CONSTRAINT conveyor_params_access_pkey PRIMARY KEY (id);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: nodes_transits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes_transits
    ADD CONSTRAINT nodes_transits_pkey PRIMARY KEY (id);


--
-- Name: pk_conveyor_params_access; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access
    ADD CONSTRAINT pk_conveyor_params_access PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, user_id);


--
-- Name: pk_register_stream_counters; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters
    ADD CONSTRAINT pk_register_stream_counters PRIMARY KEY (conveyor_id, node_id, ts, key);


--
-- Name: pk_stream_counters; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters
    ADD CONSTRAINT pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);


--
-- Name: register_stream_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters_old
    ADD CONSTRAINT register_stream_counters_pkey PRIMARY KEY (id);


--
-- Name: tasks_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_archive
    ADD CONSTRAINT tasks_archive_pkey PRIMARY KEY (id);


--
-- Name: tasks_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_group_privilegies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);


--
-- Name: charts_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX charts_dashboard_id ON charts USING btree (dashboard_id);


--
-- Name: charts_id_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX charts_id_dashboard_id ON charts USING btree (id, dashboard_id);


--
-- Name: ix_conveyor_params_access_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_params_access_id ON conveyor_params_access USING btree (id);


--
-- Name: ix_register_stream_counters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_register_stream_counters_id ON register_stream_counters USING btree (id);


--
-- Name: ix_stream_counters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stream_counters_id ON stream_counters USING btree (id);


--
-- Name: nodes_conveyor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_conveyor_id ON nodes USING btree (conveyor_id);


--
-- Name: nodes_conveyor_id_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_conveyor_id_type ON nodes USING btree (conveyor_id, type);


--
-- Name: nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id ON nodes_transits USING btree (conveyor_id, to_conveyor_id, node_id, to_node_id);


--
-- Name: register_stream_counters_conveyor_id_ts_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX register_stream_counters_conveyor_id_ts_node_id ON register_stream_counters_old USING btree (conveyor_id, ts, node_id);


--
-- Name: stream_counters_conveyor_id_ts_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_counters_conveyor_id_ts_node_id ON stream_counters_old USING btree (conveyor_id, ts, node_id);


--
-- Name: tasks_archive_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_change_time ON tasks_archive USING btree (change_time);


--
-- Name: tasks_archive_conveyor_id_node_id_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_node_id_change_time ON tasks_archive USING btree (conveyor_id, node_id, change_time) WHERE (node_id IS NOT NULL);


--
-- Name: tasks_archive_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_reference ON tasks_archive USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);


--
-- Name: tasks_archive_conveyor_id_task_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_task_id ON tasks_archive USING btree (conveyor_id, task_id) WHERE (task_id IS NOT NULL);


--
-- Name: tasks_conveyor_id_node_id_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_conveyor_id_node_id_status ON tasks USING btree (conveyor_id, node_id, status);


--
-- Name: tasks_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tasks_conveyor_id_reference ON tasks USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);


--
-- Name: tasks_history_conveyor_id_create_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_create_time ON tasks_history USING btree (conveyor_id, create_time);


--
-- Name: tasks_history_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_reference ON tasks_history USING btree (conveyor_id, reference);


--
-- Name: tasks_history_conveyor_id_task_id_create_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_task_id_create_time ON tasks_history USING btree (conveyor_id, task_id, create_time);


--
-- Name: tasks_node_id_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_node_id_change_time ON tasks USING btree (node_id, change_time);


--
-- Name: tasks_node_id_dynamic_timer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_node_id_dynamic_timer ON tasks USING btree (node_id, dynamic_timer);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: charts; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE charts FROM PUBLIC;
REVOKE ALL ON TABLE charts FROM postgres;
GRANT ALL ON TABLE charts TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE charts TO appusers;


--
-- Name: conveyor_params_access; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_params_access FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_params_access FROM postgres;
GRANT ALL ON TABLE conveyor_params_access TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_params_access TO appusers;


--
-- Name: conveyor_params_access_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_params_access_old FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_params_access_old FROM postgres;
GRANT ALL ON TABLE conveyor_params_access_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_params_access_old TO appusers;


--
-- Name: conveyor_params_access_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE conveyor_params_access_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE conveyor_params_access_id_seq FROM postgres;
GRANT ALL ON SEQUENCE conveyor_params_access_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE conveyor_params_access_id_seq TO appusers;


--
-- Name: nodes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE nodes FROM PUBLIC;
REVOKE ALL ON TABLE nodes FROM postgres;
GRANT ALL ON TABLE nodes TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nodes TO appusers;


--
-- Name: nodes_transits; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE nodes_transits FROM PUBLIC;
REVOKE ALL ON TABLE nodes_transits FROM postgres;
GRANT ALL ON TABLE nodes_transits TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nodes_transits TO appusers;


--
-- Name: nodes_transits_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE nodes_transits_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodes_transits_id_seq FROM postgres;
GRANT ALL ON SEQUENCE nodes_transits_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE nodes_transits_id_seq TO appusers;


--
-- Name: register_stream_counters; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE register_stream_counters FROM PUBLIC;
REVOKE ALL ON TABLE register_stream_counters FROM postgres;
GRANT ALL ON TABLE register_stream_counters TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE register_stream_counters TO appusers;


--
-- Name: register_stream_counters_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE register_stream_counters_old FROM PUBLIC;
REVOKE ALL ON TABLE register_stream_counters_old FROM postgres;
GRANT ALL ON TABLE register_stream_counters_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE register_stream_counters_old TO appusers;


--
-- Name: register_stream_counters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE register_stream_counters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE register_stream_counters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE register_stream_counters_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE register_stream_counters_id_seq TO appusers;


--
-- Name: stream_counters; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stream_counters FROM PUBLIC;
REVOKE ALL ON TABLE stream_counters FROM postgres;
GRANT ALL ON TABLE stream_counters TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stream_counters TO appusers;


--
-- Name: stream_counters_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stream_counters_old FROM PUBLIC;
REVOKE ALL ON TABLE stream_counters_old FROM postgres;
GRANT ALL ON TABLE stream_counters_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stream_counters_old TO appusers;


--
-- Name: stream_counters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE stream_counters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE stream_counters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE stream_counters_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE stream_counters_id_seq TO appusers;


--
-- Name: tasks; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks FROM PUBLIC;
REVOKE ALL ON TABLE tasks FROM postgres;
GRANT ALL ON TABLE tasks TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks TO appusers;


--
-- Name: tasks_archive; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks_archive FROM PUBLIC;
REVOKE ALL ON TABLE tasks_archive FROM postgres;
GRANT ALL ON TABLE tasks_archive TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks_archive TO appusers;


--
-- Name: tasks_archive_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tasks_archive_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tasks_archive_id_seq FROM postgres;
GRANT ALL ON SEQUENCE tasks_archive_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE tasks_archive_id_seq TO appusers;


--
-- Name: tasks_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks_history FROM PUBLIC;
REVOKE ALL ON TABLE tasks_history FROM postgres;
GRANT ALL ON TABLE tasks_history TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks_history TO appusers;


--
-- Name: tasks_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tasks_history_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tasks_history_id_seq FROM postgres;
GRANT ALL ON SEQUENCE tasks_history_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE tasks_history_id_seq TO appusers;


--
-- Name: user_group_privilegies; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_group_privilegies FROM PUBLIC;
REVOKE ALL ON TABLE user_group_privilegies FROM postgres;
GRANT ALL ON TABLE user_group_privilegies TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_group_privilegies TO appusers;


--
-- Name: user_group_privilegies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_group_privilegies_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_group_privilegies_id_seq TO appusers;


--
-- PostgreSQL database dump complete
--

\connect cp1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_repack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_repack WITH SCHEMA public;


--
-- Name: EXTENSION pg_repack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_repack IS 'Reorganize tables in PostgreSQL databases with minimal locks';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: charts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE charts (
    id character(24) NOT NULL,
    dashboard_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    settings text,
    series text
);


ALTER TABLE charts OWNER TO postgres;

--
-- Name: conveyor_params_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_params_access (
    from_conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    ts integer NOT NULL,
    count integer NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE conveyor_params_access OWNER TO postgres;

--
-- Name: conveyor_params_access_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_params_access_old (
    from_conveyor_id integer,
    user_id integer,
    to_conveyor_id integer,
    ts integer,
    count integer,
    period integer,
    id bigint
)
INHERITS (conveyor_params_access);


ALTER TABLE conveyor_params_access_old OWNER TO postgres;

--
-- Name: conveyor_params_access_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE conveyor_params_access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conveyor_params_access_id_seq OWNER TO postgres;

--
-- Name: conveyor_params_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyor_params_access_id_seq OWNED BY conveyor_params_access_old.id;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nodes (
    id character(24) NOT NULL,
    conveyor_id integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    condition text,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    max_count integer DEFAULT 0 NOT NULL,
    max_time integer DEFAULT 0 NOT NULL,
    status smallint NOT NULL,
    x integer,
    y integer,
    extra text,
    version integer,
    condition_temp text,
    last_editor integer,
    last_change_time integer,
    name_temp character varying(255),
    description_temp text,
    x_temp integer,
    y_temp integer,
    extra_temp text,
    status_temp smallint DEFAULT 1 NOT NULL,
    type_temp smallint DEFAULT 1 NOT NULL
);


ALTER TABLE nodes OWNER TO postgres;

--
-- Name: nodes_transits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE nodes_transits (
    id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    to_conveyor_id integer NOT NULL,
    to_node_id character(24) NOT NULL,
    prioritet smallint,
    convert text,
    description character varying(255)
);


ALTER TABLE nodes_transits OWNER TO postgres;

--
-- Name: nodes_transits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE nodes_transits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nodes_transits_id_seq OWNER TO postgres;

--
-- Name: nodes_transits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE nodes_transits_id_seq OWNED BY nodes_transits.id;


--
-- Name: register_stream_counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE register_stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    key character varying(100) NOT NULL,
    value numeric(50,5) NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE register_stream_counters OWNER TO postgres;

--
-- Name: register_stream_counters_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE register_stream_counters_old (
    conveyor_id integer,
    node_id character(24),
    ts integer,
    key character varying(100),
    value numeric(50,5),
    period integer,
    id bigint
)
INHERITS (register_stream_counters);


ALTER TABLE register_stream_counters_old OWNER TO postgres;

--
-- Name: register_stream_counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE register_stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE register_stream_counters_id_seq OWNER TO postgres;

--
-- Name: register_stream_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE register_stream_counters_id_seq OWNED BY register_stream_counters_old.id;


--
-- Name: stream_counters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE stream_counters OWNER TO postgres;

--
-- Name: stream_counters_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE stream_counters_old (
    conveyor_id integer,
    node_id character(24),
    ts integer,
    in_count integer,
    out_count integer,
    period integer,
    id bigint
)
INHERITS (stream_counters);


ALTER TABLE stream_counters_old OWNER TO postgres;

--
-- Name: stream_counters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stream_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stream_counters_id_seq OWNER TO postgres;

--
-- Name: stream_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stream_counters_id_seq OWNED BY stream_counters_old.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks (
    id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    dynamic_timer integer DEFAULT 0 NOT NULL
);


ALTER TABLE tasks OWNER TO postgres;

--
-- Name: tasks_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks_archive (
    id integer NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    task_id character(24)
);


ALTER TABLE tasks_archive OWNER TO postgres;

--
-- Name: tasks_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tasks_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tasks_archive_id_seq OWNER TO postgres;

--
-- Name: tasks_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tasks_archive_id_seq OWNED BY tasks_archive.id;


--
-- Name: tasks_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tasks_history (
    id integer NOT NULL,
    task_id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    conveyor_prev_id integer,
    node_id character(24) NOT NULL,
    user_id integer,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    node_prev_id character(24),
    status integer DEFAULT 1 NOT NULL,
    data text,
    prev_id integer DEFAULT 0
);


ALTER TABLE tasks_history OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tasks_history_id_seq OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tasks_history_id_seq OWNED BY tasks_history.id;


--
-- Name: user_group_privilegies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    type smallint NOT NULL,
    prioritet smallint
);


ALTER TABLE user_group_privilegies OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_group_privilegies_id_seq OWNER TO postgres;

--
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access ALTER COLUMN id SET DEFAULT nextval('conveyor_params_access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access_old ALTER COLUMN id SET DEFAULT nextval('conveyor_params_access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes_transits ALTER COLUMN id SET DEFAULT nextval('nodes_transits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters ALTER COLUMN id SET DEFAULT nextval('register_stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters_old ALTER COLUMN id SET DEFAULT nextval('register_stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters ALTER COLUMN id SET DEFAULT nextval('stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters_old ALTER COLUMN id SET DEFAULT nextval('stream_counters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_archive ALTER COLUMN id SET DEFAULT nextval('tasks_archive_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_history ALTER COLUMN id SET DEFAULT nextval('tasks_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);


--
-- Name: charts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);


--
-- Name: conveyor_params_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access_old
    ADD CONSTRAINT conveyor_params_access_pkey PRIMARY KEY (id);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: nodes_transits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY nodes_transits
    ADD CONSTRAINT nodes_transits_pkey PRIMARY KEY (id);


--
-- Name: pk_conveyor_params_access; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_params_access
    ADD CONSTRAINT pk_conveyor_params_access PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, user_id);


--
-- Name: pk_register_stream_counters; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters
    ADD CONSTRAINT pk_register_stream_counters PRIMARY KEY (conveyor_id, node_id, ts, key);


--
-- Name: pk_stream_counters; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stream_counters
    ADD CONSTRAINT pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);


--
-- Name: register_stream_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY register_stream_counters_old
    ADD CONSTRAINT register_stream_counters_pkey PRIMARY KEY (id);


--
-- Name: tasks_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_archive
    ADD CONSTRAINT tasks_archive_pkey PRIMARY KEY (id);


--
-- Name: tasks_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_group_privilegies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);


--
-- Name: charts_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX charts_dashboard_id ON charts USING btree (dashboard_id);


--
-- Name: charts_id_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX charts_id_dashboard_id ON charts USING btree (id, dashboard_id);


--
-- Name: ix_conveyor_params_access_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_params_access_id ON conveyor_params_access USING btree (id);


--
-- Name: ix_register_stream_counters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_register_stream_counters_id ON register_stream_counters USING btree (id);


--
-- Name: ix_stream_counters_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_stream_counters_id ON stream_counters USING btree (id);


--
-- Name: nodes_conveyor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_conveyor_id ON nodes USING btree (conveyor_id);


--
-- Name: nodes_conveyor_id_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX nodes_conveyor_id_type ON nodes USING btree (conveyor_id, type);


--
-- Name: nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id ON nodes_transits USING btree (conveyor_id, to_conveyor_id, node_id, to_node_id);


--
-- Name: register_stream_counters_conveyor_id_ts_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX register_stream_counters_conveyor_id_ts_node_id ON register_stream_counters_old USING btree (conveyor_id, ts, node_id);


--
-- Name: stream_counters_conveyor_id_ts_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_counters_conveyor_id_ts_node_id ON stream_counters_old USING btree (conveyor_id, ts, node_id);


--
-- Name: tasks_archive_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_change_time ON tasks_archive USING btree (change_time);


--
-- Name: tasks_archive_conveyor_id_node_id_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_node_id_change_time ON tasks_archive USING btree (conveyor_id, node_id, change_time) WHERE (node_id IS NOT NULL);


--
-- Name: tasks_archive_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_reference ON tasks_archive USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);


--
-- Name: tasks_archive_conveyor_id_task_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_archive_conveyor_id_task_id ON tasks_archive USING btree (conveyor_id, task_id) WHERE (task_id IS NOT NULL);


--
-- Name: tasks_conveyor_id_node_id_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_conveyor_id_node_id_status ON tasks USING btree (conveyor_id, node_id, status);


--
-- Name: tasks_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX tasks_conveyor_id_reference ON tasks USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);


--
-- Name: tasks_history_conveyor_id_create_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_create_time ON tasks_history USING btree (conveyor_id, create_time);


--
-- Name: tasks_history_conveyor_id_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_reference ON tasks_history USING btree (conveyor_id, reference);


--
-- Name: tasks_history_conveyor_id_task_id_create_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_history_conveyor_id_task_id_create_time ON tasks_history USING btree (conveyor_id, task_id, create_time);


--
-- Name: tasks_node_id_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_node_id_change_time ON tasks USING btree (node_id, change_time);


--
-- Name: tasks_node_id_dynamic_timer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_node_id_dynamic_timer ON tasks USING btree (node_id, dynamic_timer);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: charts; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE charts FROM PUBLIC;
REVOKE ALL ON TABLE charts FROM postgres;
GRANT ALL ON TABLE charts TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE charts TO appusers;


--
-- Name: conveyor_params_access; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_params_access FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_params_access FROM postgres;
GRANT ALL ON TABLE conveyor_params_access TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_params_access TO appusers;


--
-- Name: conveyor_params_access_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE conveyor_params_access_old FROM PUBLIC;
REVOKE ALL ON TABLE conveyor_params_access_old FROM postgres;
GRANT ALL ON TABLE conveyor_params_access_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE conveyor_params_access_old TO appusers;


--
-- Name: conveyor_params_access_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE conveyor_params_access_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE conveyor_params_access_id_seq FROM postgres;
GRANT ALL ON SEQUENCE conveyor_params_access_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE conveyor_params_access_id_seq TO appusers;


--
-- Name: nodes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE nodes FROM PUBLIC;
REVOKE ALL ON TABLE nodes FROM postgres;
GRANT ALL ON TABLE nodes TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nodes TO appusers;


--
-- Name: nodes_transits; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE nodes_transits FROM PUBLIC;
REVOKE ALL ON TABLE nodes_transits FROM postgres;
GRANT ALL ON TABLE nodes_transits TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nodes_transits TO appusers;


--
-- Name: nodes_transits_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE nodes_transits_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE nodes_transits_id_seq FROM postgres;
GRANT ALL ON SEQUENCE nodes_transits_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE nodes_transits_id_seq TO appusers;


--
-- Name: register_stream_counters; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE register_stream_counters FROM PUBLIC;
REVOKE ALL ON TABLE register_stream_counters FROM postgres;
GRANT ALL ON TABLE register_stream_counters TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE register_stream_counters TO appusers;


--
-- Name: register_stream_counters_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE register_stream_counters_old FROM PUBLIC;
REVOKE ALL ON TABLE register_stream_counters_old FROM postgres;
GRANT ALL ON TABLE register_stream_counters_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE register_stream_counters_old TO appusers;


--
-- Name: register_stream_counters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE register_stream_counters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE register_stream_counters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE register_stream_counters_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE register_stream_counters_id_seq TO appusers;


--
-- Name: stream_counters; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stream_counters FROM PUBLIC;
REVOKE ALL ON TABLE stream_counters FROM postgres;
GRANT ALL ON TABLE stream_counters TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stream_counters TO appusers;


--
-- Name: stream_counters_old; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stream_counters_old FROM PUBLIC;
REVOKE ALL ON TABLE stream_counters_old FROM postgres;
GRANT ALL ON TABLE stream_counters_old TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stream_counters_old TO appusers;


--
-- Name: stream_counters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE stream_counters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE stream_counters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE stream_counters_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE stream_counters_id_seq TO appusers;


--
-- Name: tasks; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks FROM PUBLIC;
REVOKE ALL ON TABLE tasks FROM postgres;
GRANT ALL ON TABLE tasks TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks TO appusers;


--
-- Name: tasks_archive; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks_archive FROM PUBLIC;
REVOKE ALL ON TABLE tasks_archive FROM postgres;
GRANT ALL ON TABLE tasks_archive TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks_archive TO appusers;


--
-- Name: tasks_archive_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tasks_archive_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tasks_archive_id_seq FROM postgres;
GRANT ALL ON SEQUENCE tasks_archive_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE tasks_archive_id_seq TO appusers;


--
-- Name: tasks_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tasks_history FROM PUBLIC;
REVOKE ALL ON TABLE tasks_history FROM postgres;
GRANT ALL ON TABLE tasks_history TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasks_history TO appusers;


--
-- Name: tasks_history_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE tasks_history_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tasks_history_id_seq FROM postgres;
GRANT ALL ON SEQUENCE tasks_history_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE tasks_history_id_seq TO appusers;


--
-- Name: user_group_privilegies; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE user_group_privilegies FROM PUBLIC;
REVOKE ALL ON TABLE user_group_privilegies FROM postgres;
GRANT ALL ON TABLE user_group_privilegies TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE user_group_privilegies TO appusers;


--
-- Name: user_group_privilegies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_group_privilegies_id_seq FROM postgres;
GRANT ALL ON SEQUENCE user_group_privilegies_id_seq TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE user_group_privilegies_id_seq TO appusers;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

