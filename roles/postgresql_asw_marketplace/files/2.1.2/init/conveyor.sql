--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.9

-- Started on 2017-09-28 12:01:04 EEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 16426)
-- Name: api_callbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE api_callbacks (
    conveyor_id integer NOT NULL,
    hash character(40) NOT NULL,
    data text
);


ALTER TABLE api_callbacks OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 54846)
-- Name: cce_exec_time; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cce_exec_time (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    sum_time real NOT NULL,
    sum_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);


ALTER TABLE cce_exec_time OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 52469)
-- Name: channel_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE channel_storage (
    conveyor_id integer NOT NULL,
    channel character varying(100) NOT NULL,
    data text
);


ALTER TABLE channel_storage OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16432)
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
    company_id character varying(25) NOT NULL,
    status smallint DEFAULT 1
);


ALTER TABLE companies OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 16440)
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
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 184
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- TOC entry 229 (class 1259 OID 19686)
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
-- TOC entry 185 (class 1259 OID 16445)
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
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 185
-- Name: conveyor_billing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyor_billing_id_seq OWNED BY conveyor_billing.id;


--
-- TOC entry 228 (class 1259 OID 19541)
-- Name: conveyor_called_timers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_called_timers (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    called_count integer NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL
);


ALTER TABLE conveyor_called_timers OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 108829)
-- Name: conveyor_id_to_conveyor_ref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_id_to_conveyor_ref (
    conveyor_ref character varying(255) NOT NULL,
    env character varying(10) NOT NULL,
    conveyor_id integer NOT NULL
);


ALTER TABLE conveyor_id_to_conveyor_ref OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16447)
-- Name: conveyor_to_shard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE conveyor_to_shard (
    conveyor_id integer NOT NULL,
    shard character varying(255) NOT NULL
);


ALTER TABLE conveyor_to_shard OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16450)
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
    esc_conv integer,
    conv_type smallint,
    company_id character varying(25),
    blocked_reason character varying(2000) DEFAULT NULL::character varying
);


ALTER TABLE conveyors OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16459)
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
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 188
-- Name: conveyors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE conveyors_id_seq OWNED BY conveyors.id;


--
-- TOC entry 189 (class 1259 OID 16461)
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
    charts_order text,
    timerange text,
    grid text
);


ALTER TABLE dashboards OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 16470)
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
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 190
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dashboards_id_seq OWNED BY dashboards.id;


--
-- TOC entry 191 (class 1259 OID 16472)
-- Name: esc_conv_to_convs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE esc_conv_to_convs (
    esc_conv integer NOT NULL,
    conv integer NOT NULL
);


ALTER TABLE esc_conv_to_convs OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 16475)
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
-- TOC entry 193 (class 1259 OID 16478)
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
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 193
-- Name: folder_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folder_content_id_seq OWNED BY folder_content.id;


--
-- TOC entry 194 (class 1259 OID 16480)
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
-- TOC entry 195 (class 1259 OID 16490)
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
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 195
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folders_id_seq OWNED BY folders.id;


--
-- TOC entry 196 (class 1259 OID 16492)
-- Name: group_to_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE group_to_group (
    parent_group_id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL
);


ALTER TABLE group_to_group OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16495)
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
-- TOC entry 198 (class 1259 OID 16501)
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
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 198
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE history_id_seq OWNED BY history.id;


--
-- TOC entry 199 (class 1259 OID 16503)
-- Name: login_to_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE login_to_users (
    user_id integer NOT NULL,
    login_id integer NOT NULL
);


ALTER TABLE login_to_users OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16506)
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
-- TOC entry 201 (class 1259 OID 16513)
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
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 201
-- Name: logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE logins_id_seq OWNED BY logins.id;


--
-- TOC entry 202 (class 1259 OID 16515)
-- Name: market_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE market_template (
    id integer NOT NULL,
    version character varying(20),
    title character varying(255) NOT NULL,
    description text,
    image character varying(500),
    repository_url character varying(500) NOT NULL,
    name character varying(255) NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    category_id smallint,
    change_time integer,
    conveyor_params text,
    owner_id integer NOT NULL,
    last_editor_id integer NOT NULL
);


ALTER TABLE market_template OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16522)
-- Name: market_template_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE market_template_history (
    id integer NOT NULL,
    market_template_id integer NOT NULL,
    description text,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    last_editor_id integer
);


ALTER TABLE market_template_history OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16529)
-- Name: market_template_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE market_template_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE market_template_history_id_seq OWNER TO postgres;

--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 204
-- Name: market_template_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE market_template_history_id_seq OWNED BY market_template_history.id;


--
-- TOC entry 205 (class 1259 OID 16531)
-- Name: market_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE market_template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE market_template_id_seq OWNER TO postgres;

--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 205
-- Name: market_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE market_template_id_seq OWNED BY market_template.id;


--
-- TOC entry 206 (class 1259 OID 18121)
-- Name: payment_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payment_history (
    id integer NOT NULL,
    order_id character(24),
    user_id integer,
    "time" integer DEFAULT (date_part('epoch'::text, now()))::integer,
    status smallint,
    card character(4),
    amount smallint,
    plan_id smallint
);


ALTER TABLE payment_history OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 18125)
-- Name: payment_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payment_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment_history_id_seq OWNER TO postgres;

--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 207
-- Name: payment_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payment_history_id_seq OWNED BY payment_history.id;


--
-- TOC entry 208 (class 1259 OID 18130)
-- Name: payment_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE payment_plans (
    id integer NOT NULL,
    title character(24),
    stripe_plan_id character(24),
    amount integer,
    tps integer,
    tacts bigint,
    currency character(3),
    "interval" character(10)
);


ALTER TABLE payment_plans OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 18133)
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
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 209
-- Name: payment_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE payment_plans_id_seq OWNED BY payment_plans.id;


--
-- TOC entry 232 (class 1259 OID 108823)
-- Name: payments_history_id_pk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE payments_history_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payments_history_id_pk_seq OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 108832)
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
    payment_id character varying(255),
    id_pk integer DEFAULT nextval('payments_history_id_pk_seq'::regclass) NOT NULL
);


ALTER TABLE payments_history OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 18138)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    order_id character(24),
    plan_id integer,
    user_id integer,
    status smallint,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    cancel_time integer,
    customer_id text,
    subscription_id text
);


ALTER TABLE subscriptions OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 18145)
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriptions_id_seq OWNER TO postgres;

--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 211
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- TOC entry 233 (class 1259 OID 108825)
-- Name: user_billing_stats_id_pk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_billing_stats_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_billing_stats_id_pk_seq OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 108843)
-- Name: user_billing_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_billing_stats (
    user_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    conveyor_tacts bigint,
    "timestamp" integer,
    "interval" integer,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('user_billing_stats_id_pk_seq'::regclass) NOT NULL
);


ALTER TABLE user_billing_stats OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 108827)
-- Name: user_billing_tacts_id_pk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_billing_tacts_id_pk_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_billing_tacts_id_pk_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 108848)
-- Name: user_billing_tacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_billing_tacts (
    user_id integer NOT NULL,
    tacts bigint NOT NULL,
    "timestamp" integer NOT NULL,
    "interval" integer NOT NULL,
    operations bigint DEFAULT 0,
    id_pk integer DEFAULT nextval('user_billing_tacts_id_pk_seq'::regclass) NOT NULL
);


ALTER TABLE user_billing_tacts OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 18150)
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
-- TOC entry 213 (class 1259 OID 18158)
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
-- TOC entry 214 (class 1259 OID 18167)
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
-- TOC entry 215 (class 1259 OID 18173)
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
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 215
-- Name: user_group_privilegies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_group_privilegies_id_seq OWNED BY user_group_privilegies.id;


--
-- TOC entry 216 (class 1259 OID 18182)
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
-- TOC entry 217 (class 1259 OID 18188)
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
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 217
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;


--
-- TOC entry 218 (class 1259 OID 18193)
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
-- TOC entry 219 (class 1259 OID 18201)
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
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 219
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- TOC entry 220 (class 1259 OID 18206)
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
-- TOC entry 221 (class 1259 OID 18209)
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
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 221
-- Name: user_to_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_to_companies_id_seq OWNED BY user_to_companies.id;


--
-- TOC entry 222 (class 1259 OID 18214)
-- Name: user_to_payment_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_to_payment_plan (
    id integer NOT NULL,
    user_id integer,
    status smallint,
    card character(4),
    expire_date integer,
    plan_id integer
);


ALTER TABLE user_to_payment_plan OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 18217)
-- Name: user_to_payment_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_to_payment_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_to_payment_plan_id_seq OWNER TO postgres;

--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 223
-- Name: user_to_payment_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_to_payment_plan_id_seq OWNED BY user_to_payment_plan.id;


--
-- TOC entry 224 (class 1259 OID 18225)
-- Name: user_to_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_to_user_groups (
    user_group_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE user_to_user_groups OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 18231)
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
-- TOC entry 226 (class 1259 OID 18240)
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
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 226
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 227 (class 1259 OID 18245)
-- Name: web_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE web_settings (
    key character(50) NOT NULL,
    value text
);


ALTER TABLE web_settings OWNER TO postgres;

--
-- TOC entry 3101 (class 2604 OID 16621)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- TOC entry 3144 (class 2604 OID 19689)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing ALTER COLUMN id SET DEFAULT nextval('conveyor_billing_id_seq'::regclass);


--
-- TOC entry 3107 (class 2604 OID 16623)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyors ALTER COLUMN id SET DEFAULT nextval('conveyors_id_seq'::regclass);


--
-- TOC entry 3111 (class 2604 OID 16624)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dashboards ALTER COLUMN id SET DEFAULT nextval('dashboards_id_seq'::regclass);


--
-- TOC entry 3112 (class 2604 OID 16625)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folder_content ALTER COLUMN id SET DEFAULT nextval('folder_content_id_seq'::regclass);


--
-- TOC entry 3117 (class 2604 OID 16626)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folders ALTER COLUMN id SET DEFAULT nextval('folders_id_seq'::regclass);


--
-- TOC entry 3118 (class 2604 OID 16627)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);


--
-- TOC entry 3120 (class 2604 OID 16628)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logins ALTER COLUMN id SET DEFAULT nextval('logins_id_seq'::regclass);


--
-- TOC entry 3122 (class 2604 OID 16629)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY market_template ALTER COLUMN id SET DEFAULT nextval('market_template_id_seq'::regclass);


--
-- TOC entry 3124 (class 2604 OID 16630)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY market_template_history ALTER COLUMN id SET DEFAULT nextval('market_template_history_id_seq'::regclass);


--
-- TOC entry 3126 (class 2604 OID 18127)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_history ALTER COLUMN id SET DEFAULT nextval('payment_history_id_seq'::regclass);


--
-- TOC entry 3127 (class 2604 OID 18135)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_plans ALTER COLUMN id SET DEFAULT nextval('payment_plans_id_seq'::regclass);


--
-- TOC entry 3129 (class 2604 OID 18147)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- TOC entry 3130 (class 2604 OID 18175)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('user_group_privilegies_id_seq'::regclass);


--
-- TOC entry 3134 (class 2604 OID 18190)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);


--
-- TOC entry 3137 (class 2604 OID 18203)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- TOC entry 3138 (class 2604 OID 18211)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_companies ALTER COLUMN id SET DEFAULT nextval('user_to_companies_id_seq'::regclass);


--
-- TOC entry 3139 (class 2604 OID 18219)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_payment_plan ALTER COLUMN id SET DEFAULT nextval('user_to_payment_plan_id_seq'::regclass);


--
-- TOC entry 3143 (class 2604 OID 18242)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 3156 (class 2606 OID 17155)
-- Name: api_callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY api_callbacks
    ADD CONSTRAINT api_callbacks_pkey PRIMARY KEY (conveyor_id);


--
-- TOC entry 3236 (class 2606 OID 52476)
-- Name: channel_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY channel_storage
    ADD CONSTRAINT channel_storage_pkey PRIMARY KEY (conveyor_id, channel);


--
-- TOC entry 3159 (class 2606 OID 17161)
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- TOC entry 3240 (class 2606 OID 108854)
-- Name: conveyor_id_to_conveyor_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_id_to_conveyor_ref
    ADD CONSTRAINT conveyor_id_to_conveyor_ref_pkey PRIMARY KEY (conveyor_ref, env);


--
-- TOC entry 3162 (class 2606 OID 17181)
-- Name: conveyor_to_shard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_to_shard
    ADD CONSTRAINT conveyor_to_shard_pkey PRIMARY KEY (conveyor_id);


--
-- TOC entry 3165 (class 2606 OID 17177)
-- Name: conveyors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyors
    ADD CONSTRAINT conveyors_pkey PRIMARY KEY (id);


--
-- TOC entry 3169 (class 2606 OID 17416)
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- TOC entry 3171 (class 2606 OID 17430)
-- Name: esc_conv_to_convs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY esc_conv_to_convs
    ADD CONSTRAINT esc_conv_to_convs_pkey PRIMARY KEY (esc_conv, conv);


--
-- TOC entry 3175 (class 2606 OID 17433)
-- Name: folder_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folder_content
    ADD CONSTRAINT folder_content_pkey PRIMARY KEY (id);


--
-- TOC entry 3178 (class 2606 OID 17440)
-- Name: folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- TOC entry 3181 (class 2606 OID 17444)
-- Name: group_to_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY group_to_group
    ADD CONSTRAINT group_to_group_pkey PRIMARY KEY (parent_group_id, group_id, conveyor_id);


--
-- TOC entry 3184 (class 2606 OID 17451)
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 3186 (class 2606 OID 17461)
-- Name: login_to_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY login_to_users
    ADD CONSTRAINT login_to_users_pkey PRIMARY KEY (user_id, login_id);


--
-- TOC entry 3189 (class 2606 OID 17457)
-- Name: logins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);


--
-- TOC entry 3191 (class 2606 OID 18129)
-- Name: payment_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_history
    ADD CONSTRAINT payment_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3193 (class 2606 OID 18137)
-- Name: payment_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payment_plans
    ADD CONSTRAINT payment_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 54850)
-- Name: pk_cce_exec_time; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cce_exec_time
    ADD CONSTRAINT pk_cce_exec_time PRIMARY KEY (conveyor_id, node_id, ts);


--
-- TOC entry 3234 (class 2606 OID 19695)
-- Name: pk_conveyor_billing; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_billing
    ADD CONSTRAINT pk_conveyor_billing PRIMARY KEY (conveyor_id, user_id, ts);


--
-- TOC entry 3228 (class 2606 OID 19545)
-- Name: pk_conveyor_called_timers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY conveyor_called_timers
    ADD CONSTRAINT pk_conveyor_called_timers PRIMARY KEY (conveyor_id, node_id, ts);


--
-- TOC entry 3244 (class 2606 OID 108856)
-- Name: pk_payments_history; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY payments_history
    ADD CONSTRAINT pk_payments_history PRIMARY KEY (id_pk);


--
-- TOC entry 3246 (class 2606 OID 108858)
-- Name: pk_user_billing_stats; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_billing_stats
    ADD CONSTRAINT pk_user_billing_stats PRIMARY KEY (id_pk);


--
-- TOC entry 3250 (class 2606 OID 108860)
-- Name: pk_user_billing_tacts; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_billing_tacts
    ADD CONSTRAINT pk_user_billing_tacts PRIMARY KEY (id_pk);


--
-- TOC entry 3195 (class 2606 OID 18149)
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 3197 (class 2606 OID 18157)
-- Name: user_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_dashboards
    ADD CONSTRAINT user_dashboards_pkey PRIMARY KEY (group_id, dashboard_id, level);


--
-- TOC entry 3200 (class 2606 OID 18165)
-- Name: user_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_folders
    ADD CONSTRAINT user_folders_pkey PRIMARY KEY (group_id, folder_id, level);


--
-- TOC entry 3206 (class 2606 OID 18177)
-- Name: user_group_privilegies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);


--
-- TOC entry 3208 (class 2606 OID 18192)
-- Name: user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 18205)
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3212 (class 2606 OID 18213)
-- Name: user_to_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_companies
    ADD CONSTRAINT user_to_companies_pkey PRIMARY KEY (company_id, user_id);


--
-- TOC entry 3216 (class 2606 OID 18221)
-- Name: user_to_payment_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_payment_plan
    ADD CONSTRAINT user_to_payment_plan_pkey PRIMARY KEY (id);


--
-- TOC entry 3219 (class 2606 OID 18229)
-- Name: user_to_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_to_user_groups
    ADD CONSTRAINT user_to_user_groups_pkey PRIMARY KEY (user_group_id, user_id);


--
-- TOC entry 3222 (class 2606 OID 18244)
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 18895)
-- Name: web_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (key);


--
-- TOC entry 3154 (class 1259 OID 17156)
-- Name: api_callbacks_hash_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX api_callbacks_hash_id ON api_callbacks USING btree (hash);


--
-- TOC entry 3157 (class 1259 OID 17162)
-- Name: companies_company_id_owner_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX companies_company_id_owner_user_id ON companies USING btree (id, owner_user_id);


--
-- TOC entry 3225 (class 1259 OID 19546)
-- Name: conveyor_called_timers_conv_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyor_called_timers_conv_id_ts ON conveyor_called_timers USING btree (conveyor_id, ts);


--
-- TOC entry 3226 (class 1259 OID 19547)
-- Name: conveyor_called_timers_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyor_called_timers_ts ON conveyor_called_timers USING btree (ts);


--
-- TOC entry 3160 (class 1259 OID 17182)
-- Name: conveyor_to_shard_conveyor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX conveyor_to_shard_conveyor_id ON conveyor_to_shard USING btree (conveyor_id, shard);


--
-- TOC entry 3163 (class 1259 OID 17178)
-- Name: conveyors_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyors_name ON conveyors USING btree (lower((name)::text) varchar_pattern_ops);


--
-- TOC entry 3166 (class 1259 OID 23045)
-- Name: conveyors_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conveyors_status ON conveyors USING btree (status);


--
-- TOC entry 3172 (class 1259 OID 17434)
-- Name: folder_content_folder_id_obj_type_obj_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX folder_content_folder_id_obj_type_obj_id ON folder_content USING btree (folder_id, obj_type, obj_id);


--
-- TOC entry 3173 (class 1259 OID 17435)
-- Name: folder_content_obj_type_obj_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX folder_content_obj_type_obj_id ON folder_content USING btree (obj_type, obj_id);


--
-- TOC entry 3176 (class 1259 OID 17441)
-- Name: folders_owner_id_type_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX folders_owner_id_type_status ON folders USING btree (owner_id, type, status);


--
-- TOC entry 3179 (class 1259 OID 23044)
-- Name: folders_status_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX folders_status_type ON folders USING btree (status, type);


--
-- TOC entry 3182 (class 1259 OID 17452)
-- Name: history_obj_id_obj_type_change_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX history_obj_id_obj_type_change_time ON history USING btree (obj_id, obj_type, change_time);


--
-- TOC entry 3229 (class 1259 OID 19691)
-- Name: ix_conveyor_billing_conveyor_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_conveyor_id_ts ON conveyor_billing USING btree (conveyor_id, ts);


--
-- TOC entry 3230 (class 1259 OID 19690)
-- Name: ix_conveyor_billing_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_id ON conveyor_billing USING btree (id);


--
-- TOC entry 3231 (class 1259 OID 19692)
-- Name: ix_conveyor_billing_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_ts ON conveyor_billing USING btree (ts);


--
-- TOC entry 3232 (class 1259 OID 19693)
-- Name: ix_conveyor_billing_user_id_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conveyor_billing_user_id_ts ON conveyor_billing USING btree (user_id, ts);


--
-- TOC entry 3187 (class 1259 OID 17458)
-- Name: logins_login_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX logins_login_type ON logins USING btree (login, type);


--
-- TOC entry 3167 (class 1259 OID 19146)
-- Name: owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX owner_id ON conveyors USING btree (owner_id);


--
-- TOC entry 3241 (class 1259 OID 108861)
-- Name: payment_history_order_by_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_history_order_by_user ON payments_history USING btree (user_id, order_id);


--
-- TOC entry 3242 (class 1259 OID 108862)
-- Name: payment_history_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_history_order_id ON payments_history USING btree (order_id);


--
-- TOC entry 3213 (class 1259 OID 18222)
-- Name: payment_history_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_history_user_id ON user_to_payment_plan USING btree (user_id);


--
-- TOC entry 3214 (class 1259 OID 18223)
-- Name: subscriptions_user_id_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subscriptions_user_id_plan_id ON user_to_payment_plan USING btree (user_id, plan_id);


--
-- TOC entry 3247 (class 1259 OID 108863)
-- Name: user_billing_stats_user_to_conv_on_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_billing_stats_user_to_conv_on_timestamp ON user_billing_stats USING btree (user_id, conveyor_id, "timestamp");


--
-- TOC entry 3248 (class 1259 OID 108864)
-- Name: user_billing_tacts_user_to_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_billing_tacts_user_to_timestamp ON user_billing_stats USING btree (user_id, "timestamp");


--
-- TOC entry 3198 (class 1259 OID 18166)
-- Name: user_folders_folder_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_folders_folder_id ON user_folders USING btree (folder_id);


--
-- TOC entry 3201 (class 1259 OID 18178)
-- Name: user_group_privilegies_conveyor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_privilegies_conveyor_id ON user_group_privilegies USING btree (conveyor_id);


--
-- TOC entry 3202 (class 1259 OID 18179)
-- Name: user_group_privilegies_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_privilegies_group_id ON user_group_privilegies USING btree (group_id);


--
-- TOC entry 3203 (class 1259 OID 18180)
-- Name: user_group_privilegies_group_id_conveyor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_group_privilegies_group_id_conveyor_id ON user_group_privilegies USING btree (group_id, conveyor_id);


--
-- TOC entry 3204 (class 1259 OID 18181)
-- Name: user_group_privilegies_group_id_conveyor_id_node_id_prioritet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_group_privilegies_group_id_conveyor_id_node_id_prioritet ON user_group_privilegies USING btree (group_id, conveyor_id, node_id, prioritet) WHERE (node_id IS NOT NULL);


--
-- TOC entry 3217 (class 1259 OID 18224)
-- Name: user_to_payment_plan_user_id_plan_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_to_payment_plan_user_id_plan_id ON user_to_payment_plan USING btree (user_id, plan_id);


--
-- TOC entry 3220 (class 1259 OID 18230)
-- Name: user_to_user_groups_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_to_user_groups_user_id ON user_to_user_groups USING btree (user_id);


-- Completed on 2017-09-28 12:01:35 EEST

--
-- PostgreSQL database dump complete
--

