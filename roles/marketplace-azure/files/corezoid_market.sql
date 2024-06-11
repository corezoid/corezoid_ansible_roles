--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: categories; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE categories (
    id integer NOT NULL,
    alias character varying(255) NOT NULL,
    title jsonb NOT NULL,
    color character varying(10) NOT NULL,
    sort_index integer DEFAULT 0
);


ALTER TABLE categories OWNER TO superuser;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO superuser;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE customers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    stripe_customer_id character varying(500),
    created_at integer NOT NULL,
    updated_at integer,
    card character varying(4),
    card_date character varying(7),
    card_brand character varying(20)
);


ALTER TABLE customers OWNER TO superuser;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_id_seq OWNER TO superuser;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: download_history; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE download_history (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at integer NOT NULL,
    product_id integer
);


ALTER TABLE download_history OWNER TO superuser;

--
-- Name: download_history_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE download_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE download_history_id_seq OWNER TO superuser;

--
-- Name: download_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE download_history_id_seq OWNED BY download_history.id;


--
-- Name: market_stats; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE market_stats (
    id integer NOT NULL,
    metrics character varying(255) NOT NULL,
    count integer
);


ALTER TABLE market_stats OWNER TO superuser;

--
-- Name: market_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE market_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE market_stats_id_seq OWNER TO superuser;

--
-- Name: market_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE market_stats_id_seq OWNED BY market_stats.id;


--
-- Name: moderation_history; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE moderation_history (
    id integer NOT NULL,
    alias character varying(255) NOT NULL,
    moderator_id integer,
    moderator_name character varying(1000),
    change_log jsonb NOT NULL,
    status character varying(100) NOT NULL,
    version integer DEFAULT 0 NOT NULL,
    comments text,
    created_at integer NOT NULL,
    moderated_at integer
);


ALTER TABLE moderation_history OWNER TO superuser;

--
-- Name: moderation_history_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE moderation_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moderation_history_id_seq OWNER TO superuser;

--
-- Name: moderation_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE moderation_history_id_seq OWNED BY moderation_history.id;


--
-- Name: moderation_products; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE moderation_products (
    id integer NOT NULL,
    alias character varying(255) NOT NULL,
    title jsonb NOT NULL,
    description jsonb NOT NULL,
    short_description jsonb NOT NULL,
    logo character varying(1000),
    path_to_template character varying(1000) NOT NULL,
    params text,
    owner_id integer NOT NULL,
    folder_id integer NOT NULL,
    company_id character varying(255) NOT NULL,
    version integer DEFAULT 0,
    price integer DEFAULT 0,
    created_at integer NOT NULL,
    cat_id integer,
    presentation character varying(2044)
);


ALTER TABLE moderation_products OWNER TO superuser;

--
-- Name: moderation_products_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE moderation_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moderation_products_id_seq OWNER TO superuser;

--
-- Name: moderation_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE moderation_products_id_seq OWNED BY moderation_products.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE payments (
    id integer NOT NULL,
    order_id character varying(500) NOT NULL,
    seller_id integer NOT NULL,
    customer_id integer NOT NULL,
    amount integer NOT NULL,
    market_fee integer,
    seller_payout integer,
    status character varying(100) NOT NULL,
    pay_type character varying(100) NOT NULL,
    created_at integer NOT NULL,
    updated_at integer,
    product_id integer
);


ALTER TABLE payments OWNER TO superuser;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payments_id_seq OWNER TO superuser;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE products (
    id integer NOT NULL,
    alias character varying(255) NOT NULL,
    title jsonb NOT NULL,
    description jsonb NOT NULL,
    short_description jsonb NOT NULL,
    logo character varying(1000),
    path_to_template character varying(1000) NOT NULL,
    params text,
    rate double precision DEFAULT 0,
    count_rate integer DEFAULT 0,
    downloads integer DEFAULT 0,
    views integer DEFAULT 0,
    owner_id integer NOT NULL,
    folder_id integer NOT NULL,
    company_id character varying(255) NOT NULL,
    version integer DEFAULT 0,
    slider boolean DEFAULT false NOT NULL,
    slider_logo character varying(1000),
    status character varying(100) NOT NULL,
    price integer DEFAULT 0,
    created_at integer NOT NULL,
    updated_at integer,
    cat_id integer,
    presentation character varying(2044)
);


ALTER TABLE products OWNER TO superuser;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE products_id_seq OWNER TO superuser;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: sellers; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE sellers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    info jsonb NOT NULL,
    pay_system character varying(100) NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE sellers OWNER TO superuser;

--
-- Name: sellers_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE sellers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sellers_id_seq OWNER TO superuser;

--
-- Name: sellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE sellers_id_seq OWNED BY sellers.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: superuser
--

CREATE TABLE votes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    rate integer NOT NULL,
    created_at integer NOT NULL,
    updated_at integer,
    product_id integer
);


ALTER TABLE votes OWNER TO superuser;

--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: superuser
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE votes_id_seq OWNER TO superuser;

--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: superuser
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: download_history id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY download_history ALTER COLUMN id SET DEFAULT nextval('download_history_id_seq'::regclass);


--
-- Name: market_stats id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY market_stats ALTER COLUMN id SET DEFAULT nextval('market_stats_id_seq'::regclass);


--
-- Name: moderation_history id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY moderation_history ALTER COLUMN id SET DEFAULT nextval('moderation_history_id_seq'::regclass);


--
-- Name: moderation_products id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY moderation_products ALTER COLUMN id SET DEFAULT nextval('moderation_products_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: sellers id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY sellers ALTER COLUMN id SET DEFAULT nextval('sellers_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: download_history download_history_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY download_history
    ADD CONSTRAINT download_history_pkey PRIMARY KEY (id);


--
-- Name: market_stats market_stats_metrics_key; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY market_stats
    ADD CONSTRAINT market_stats_metrics_key UNIQUE (metrics);


--
-- Name: market_stats market_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY market_stats
    ADD CONSTRAINT market_stats_pkey PRIMARY KEY (id);


--
-- Name: moderation_history moderation_history_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY moderation_history
    ADD CONSTRAINT moderation_history_pkey PRIMARY KEY (id);


--
-- Name: moderation_products moderation_products_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY moderation_products
    ADD CONSTRAINT moderation_products_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: categories_alias; Type: INDEX; Schema: public; Owner: superuser
--

CREATE UNIQUE INDEX categories_alias ON categories USING btree (alias);


--
-- Name: customers_user_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX customers_user_id ON customers USING btree (user_id);


--
-- Name: download_history_product_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX download_history_product_id ON download_history USING btree (product_id);


--
-- Name: download_history_user_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX download_history_user_id ON download_history USING btree (user_id);


--
-- Name: market_stats_metrics; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX market_stats_metrics ON market_stats USING btree (metrics);


--
-- Name: moderation_history_alias; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX moderation_history_alias ON moderation_history USING btree (alias);


--
-- Name: moderation_products_alias; Type: INDEX; Schema: public; Owner: superuser
--

CREATE UNIQUE INDEX moderation_products_alias ON moderation_products USING btree (alias);


--
-- Name: payments_customer_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX payments_customer_id ON payments USING btree (customer_id);


--
-- Name: payments_seller_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX payments_seller_id ON payments USING btree (seller_id);


--
-- Name: products_alias; Type: INDEX; Schema: public; Owner: superuser
--

CREATE UNIQUE INDEX products_alias ON products USING btree (alias);


--
-- Name: products_cat_id_created_at; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX products_cat_id_created_at ON products USING btree (cat_id, created_at);


--
-- Name: sellers_user_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE INDEX sellers_user_id ON sellers USING btree (user_id);


--
-- Name: votes_user_id_product_id; Type: INDEX; Schema: public; Owner: superuser
--

CREATE UNIQUE INDEX votes_user_id_product_id ON votes USING btree (user_id, product_id);


--
-- Name: download_history download_history_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY download_history
    ADD CONSTRAINT download_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: moderation_products moderation_products_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY moderation_products
    ADD CONSTRAINT moderation_products_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: payments payments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: products products_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: votes votes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: superuser
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

