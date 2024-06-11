

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


CREATE TABLE public.conveyor_copy_rpc_logic_statistics (
    from_conveyor_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    from_node_id character(24) NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    count integer NOT NULL
);



CREATE TABLE public.conveyor_copy_rpc_logic_validation_statistics (
    from_conveyor_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    from_node_id character(24) NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    count integer NOT NULL
);



CREATE TABLE public.conveyor_logic_statistics (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    period integer NOT NULL,
    cce_ok integer NOT NULL,
    cce_err integer NOT NULL,
    cce_timeout integer NOT NULL,
    copy_create_ok integer NOT NULL,
    copy_create_err integer NOT NULL,
    copy_modify_ok integer NOT NULL,
    copy_modify_err integer NOT NULL,
    get_task_ok integer NOT NULL,
    get_task_err integer NOT NULL,
    http_ok integer NOT NULL,
    http_err integer NOT NULL,
    modify_task_ok integer NOT NULL,
    modify_task_err integer NOT NULL,
    rpc_ok integer NOT NULL,
    rpc_err integer NOT NULL,
    timer_called integer NOT NULL
);



ALTER TABLE ONLY public.conveyor_copy_rpc_logic_statistics
    ADD CONSTRAINT conveyor_copy_rpc_logic_statistics_pkey PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, from_node_id);



ALTER TABLE ONLY public.conveyor_copy_rpc_logic_validation_statistics
    ADD CONSTRAINT conveyor_copy_rpc_logic_validation_statistics_pkey PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, from_node_id);



ALTER TABLE ONLY public.conveyor_logic_statistics
    ADD CONSTRAINT conveyor_logic_statistics_pkey PRIMARY KEY (conveyor_id, node_id, ts);



