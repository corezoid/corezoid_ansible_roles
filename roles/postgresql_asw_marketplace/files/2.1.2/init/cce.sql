--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.9

-- Started on 2017-09-28 12:00:37 EEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 550 (class 1247 OID 17468)
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
-- TOC entry 181 (class 1259 OID 17475)
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
-- TOC entry 182 (class 1259 OID 17481)
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
-- TOC entry 183 (class 1259 OID 17487)
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
-- TOC entry 3031 (class 0 OID 0)
-- Dependencies: 183
-- Name: cce_src_temp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cce_src_temp_id_seq OWNED BY cce_src_temp.id;


--
-- TOC entry 2909 (class 2604 OID 17489)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cce_src_temp ALTER COLUMN id SET DEFAULT nextval('cce_src_temp_id_seq'::regclass);


--
-- TOC entry 2911 (class 1259 OID 18111)
-- Name: conv_node_cce_src_temp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX conv_node_cce_src_temp ON cce_src_temp USING btree (conv, node);


--
-- TOC entry 2910 (class 1259 OID 18112)
-- Name: my_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX my_index ON cce_src USING btree (conv, node);


-- Completed on 2017-09-28 12:00:43 EEST

--
-- PostgreSQL database dump complete
--

