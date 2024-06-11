\c conveyor

CREATE TABLE aliases (
    id serial PRIMARY KEY,
    name varchar(255),
    short_name varchar(128) NOT NULL,
    company_id varchar(25) NOT NULL,
    project_id integer NOT NULL DEFAULT 0,
    owner_id integer NOT NULL,
    user_id integer NOT NULL,
    obj_id integer,
    obj_type smallint,
    hash varchar(40),
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    description character varying(2000),
    status smallint DEFAULT 1,
    UNIQUE (hash, company_id, project_id)
);

CREATE UNIQUE INDEX aliases_unique_short_name ON aliases (short_name, company_id, project_id) WHERE (status <> 3);

CREATE TABLE dbcall_instance_per_user (
  user_id integer PRIMARY KEY,
  status smallint DEFAULT 1
);

CREATE SEQUENCE public.configs_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE public.configs
(
    id integer NOT NULL DEFAULT nextval('configs_id_seq'::regclass),
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    create_time integer NOT NULL DEFAULT (date_part('epoch'::text, now()))::integer,
    owner_id integer NOT NULL,
    type smallint DEFAULT 0,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    user_id integer,
    status smallint DEFAULT 1,
    company_id character varying(25) COLLATE pg_catalog."default",
    data text COLLATE pg_catalog."default",
    CONSTRAINT configs_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE public.user_configs_id_pk_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

CREATE TABLE public.user_configs
(
    config_id integer NOT NULL,
    group_id integer NOT NULL,
    level integer NOT NULL,
    privs text COLLATE pg_catalog."default",
    id_pk integer NOT NULL DEFAULT nextval('user_configs_id_pk_seq'::regclass),
    CONSTRAINT pk_user_configs PRIMARY KEY (id_pk)
);

CREATE UNIQUE INDEX user_configs_group_id_config_id_level
    ON public.user_configs USING btree
    (group_id, config_id, level)
    TABLESPACE pg_default;


GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO appusers;
GRANT SELECT,UPDATE ON ALL SEQUENCES IN SCHEMA public TO appusers;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewers;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO viewers;
