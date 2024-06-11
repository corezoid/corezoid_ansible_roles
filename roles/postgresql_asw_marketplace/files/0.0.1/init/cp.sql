

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE FUNCTION public.disconnect_inherits_table(v_table_master text, v_date timestamp with time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
v_no_inherit_ddl text:='';   --Общий скрипт отключения партиции от наследования
v_rec            record;     --Переменная курсора
BEGIN
  FOR v_rec IN (SELECT tp.partition_table pt
		FROM pg_class pgc
		INNER JOIN table_partition tp ON tp.partition_table = pgc.relname
		WHERE tp.master_table = v_table_master AND tp.is_inherit = 1 AND tp.start_range::int < extract(epoch from v_date))
	  LOOP
	        v_no_inherit_ddl := 'ALTER TABLE ' || v_rec.pt || ' NO INHERIT ' || v_table_master;
		EXECUTE v_no_inherit_ddl;
		UPDATE table_partition SET is_inherit = 0 WHERE partition_table = v_rec.pt;
	  END LOOP;
RETURN;
END;	  
$$;



CREATE FUNCTION public.partition_backup(path text, db text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
 Q record;
BEGIN
 FOR Q IN (SELECT partition_table FROM table_partition WHERE is_inherit = 0)
 LOOP
  BEGIN
   PERFORM table_backup(Q.partition_table, path, Q.partition_table, db);
   DELETE FROM table_partition WHERE partition_table = Q.partition_table;
   EXECUTE 'DROP TABLE '||Q.partition_table;
  END;
 END LOOP;
RETURN;
END;
$$;



CREATE FUNCTION public.tasks_archive_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
IF (NEW.change_time >= 1466726400 AND NEW.change_time <= 1466812799) THEN INSERT INTO tasks_archive_1466726400_1466812799 VALUES (NEW.*);
ELSIF (NEW.change_time >= 1466467200 AND NEW.change_time <= 1466553599) THEN INSERT INTO tasks_archive_1466467200_1466553599 VALUES (NEW.*);
ELSIF (NEW.change_time >= 1466553600 AND NEW.change_time <= 1466639999) THEN INSERT INTO tasks_archive_1466553600_1466639999 VALUES (NEW.*);
ELSIF (NEW.change_time >= 1466640000 AND NEW.change_time <= 1466726399) THEN INSERT INTO tasks_archive_1466640000_1466726399 VALUES (NEW.*);
ELSE RAISE EXCEPTION 'change_time % is out of range. You should fix tasks_archive_insert()', NEW.create_time;
END IF;
RETURN NULL;
END;
$$;



CREATE FUNCTION public.tasks_archive_new_partition() RETURNS integer
    LANGUAGE plpgsql
    AS $_$

DECLARE
v_table_master  varchar(50) := 'tasks_archive'; --Таблица для наследования
v_table_part    varchar(255) := '';             --Партиция

v_date          timestamp := date_trunc('day',current_timestamp); --Текущее время
v_interval_part interval := '86399 second';                       --Диапазон партиции
v_interval_cnt  interval := '1 day';                              --Приведения счётчика к типу inerval (не явно не приводится)
v_begin_date    varchar(20) := '';          --Начальная дата
v_end_date      varchar(20) := '';          --Конечная дата
v_cnt_part      smallint := 2;              --Необходимое кол-во партиций для создания
v_cnt           smallint;                   --Кол-в созданных партиций

v_range_checks    text:=''; -- Обобщение средней части процедуры
v_begin_ddl       text;     -- Обобщение начальной части процедуры
v_end_ddl         text;     -- Обобщение конечной части процедуры
v_max_start_range text;     -- Максимальное условие существующей партиции
v_ddl             text;     -- Динамический код для создания процедуры
v_no_inherit_ddl  text;     -- Общий скрипт отключения партиции от наследования
rec record;                 -- Курсор для извлечения данных из table_partition и формирования table_partition
inh_out record;             -- Курсор для отключения партиций от наследования

BEGIN


SELECT count(1) INTO v_cnt FROM pg_class pgc
INNER JOIN table_partition tp ON tp.partition_table = pgc.relname
WHERE tp.master_table = v_table_master AND tp.is_inherit = 1 AND tp.start_range::int > extract(epoch from (v_date));


IF (v_cnt < v_cnt_part)
THEN
 BEGIN
  FOR q in 0..v_cnt_part
  LOOP
	-- Вычисляем граничные условия партиции -------------------------------
	v_begin_date   := extract(epoch from (v_date + q*v_interval_cnt))::TEXT;
	v_end_date     := extract(epoch from (v_date + q*v_interval_cnt + v_interval_part))::TEXT;

	-- Даём имя партиции --------------------------------------------------

	v_table_part := v_table_master || '_' || v_begin_date || '_' || v_end_date;

	-- Проверяем партицию на существование --------------------------------

	PERFORM 1 FROM pg_class WHERE relname = v_table_part LIMIT 1;

	-- Если её ещё нет, то создаём ----------------------------------------

	IF NOT FOUND
	THEN

	-- Cоздаём партицию, наследуя мастер-таблицу --------------------------

        EXECUTE 'CREATE TABLE ' || v_table_part || ' ( CHECK ( change_time >= ' || v_begin_date || ' AND change_time <= ' || v_end_date || ' ), PRIMARY KEY (id) ) INHERITS (' || v_table_master || ')';

	-- Создаём индексы для текущей партиции -------------------------------

		EXECUTE 'CREATE INDEX ' || v_table_part || '_change_time ON tasks_archive_' || v_begin_date || '_' || v_end_date || ' USING btree (change_time)';
		EXECUTE 'CREATE INDEX ' || v_table_part || '_conveyor_id_node_id_change_time ON tasks_archive_' || v_begin_date || '_' || v_end_date || ' USING btree (conveyor_id, node_id, change_time)';
		EXECUTE 'CREATE INDEX ' || v_table_part || '_conveyor_id_reference ON tasks_archive_' || v_begin_date || '_' || v_end_date || ' USING btree (conveyor_id, reference)';
		EXECUTE 'CREATE INDEX ' || v_table_part || '_conveyor_id_task_id ON tasks_archive_' || v_begin_date || '_' || v_end_date || ' USING btree (conveyor_id, task_id)';

    -- Меняем владельца, если нужно ---------------------------------------

        --EXECUTE 'GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE '|| v_table_part ||' TO appusers';
        EXECUTE 'GRANT SELECT ON TABLE '|| v_table_part ||' TO viewers';
        EXECUTE 'GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE '|| v_table_part ||' TO webprod';
        EXECUTE 'GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE '|| v_table_part ||' TO convpguser';

	-- Добавляем новую партицию в таблицу логирования -------------------------

		INSERT INTO table_partition (master_table, partition_table, start_range, end_range)
		VALUES (v_table_master, v_table_part, v_begin_date, v_end_date);
        END IF;
  END LOOP;

	  --Отключаем партиции от наследования

	  --v_interval_cnt := v_cnt_inherit;

	  FOR inh_out IN (SELECT tp.partition_table pt
			  FROM pg_class pgc
			  INNER JOIN table_partition tp ON tp.partition_table = pgc.relname
			  WHERE tp.master_table = v_table_master AND tp.is_inherit = 1 AND tp.start_range::int < extract(epoch from (v_date-1*v_interval_cnt)))
	  LOOP
		v_no_inherit_ddl := 'ALTER TABLE ' || inh_out.pt || ' NO INHERIT ' || v_table_master;
		EXECUTE v_no_inherit_ddl;
		UPDATE table_partition SET is_inherit = 0 WHERE partition_table = inh_out.pt;
	  END LOOP;

        -- Процедура для обновления диапазона модификации партииции -----------

        v_begin_ddl:='CREATE OR REPLACE FUNCTION tasks_archive_insert() RETURNS TRIGGER AS $body$'||chr(10)||'BEGIN '||chr(10);
        v_end_ddl  :='ELSE RAISE EXCEPTION ''change_time % is out of range. You should fix tasks_archive_insert()'', NEW.create_time;'||chr(10)||'END IF;'||chr(10)||'RETURN NULL;'||chr(10)||'END;'||chr(10)||'$body$'||chr(10)||'LANGUAGE plpgsql;';

	SELECT max(start_range) INTO v_max_start_range FROM table_partition WHERE master_table = v_table_master;


	FOR rec IN (SELECT 'ELSIF (NEW.change_time >= '||start_range||' AND NEW.change_time <= '||end_range||') THEN INSERT INTO '||partition_table||' VALUES (NEW.*);'||chr(10) AS range_check
	            FROM table_partition
	            WHERE master_table = v_table_master and is_inherit = 1 and start_range <> v_max_start_range
	            ORDER BY start_range DESC)
	LOOP
	            v_range_checks := rec.range_check || v_range_checks;
	END LOOP;


	SELECT 'IF (NEW.change_time >= '||start_range||' AND NEW.change_time <= '||end_range||') THEN INSERT INTO '||partition_table||' VALUES (NEW.*);'||chr(10)||v_range_checks INTO v_range_checks
	FROM table_partition
	WHERE master_table = v_table_master and is_inherit = 1 and start_range = v_max_start_range;

	v_ddl := v_begin_ddl || v_range_checks || v_end_ddl;

	EXECUTE v_ddl;

    --RAISE NOTICE  'RESULT: % ', v_ddl;
    --RAISE EXCEPTION ' % ', SQLERRM;
     END;
END IF;

RETURN NULL;
/*
EXCEPTION WHEN OTHERS THEN
		BEGIN
	           INSERT INTO debug_log(log_value) VALUES (SQLERRM);
		END;
*/
END;

$_$;


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.backup_stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.charts (
    id character(24) NOT NULL,
    dashboard_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    settings text,
    series text,
    chart_type character varying(20)
);



CREATE TABLE public.conveyor_params_access (
    from_conveyor_id integer NOT NULL,
    user_id integer NOT NULL,
    to_conveyor_id integer NOT NULL,
    ts integer NOT NULL,
    count integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.node_commits_history (
    id bigint NOT NULL,
    user_id integer,
    conveyor_id integer,
    node_id character(24),
    version integer,
    name character varying(255),
    condition text,
    description text,
    x integer,
    y integer,
    extra text,
    status integer,
    type smallint,
    create_time integer
);



CREATE SEQUENCE public.node_commits_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.node_commits_history_id_seq OWNED BY public.node_commits_history.id;



CREATE TABLE public.nodes (
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
    type_temp smallint DEFAULT 1 NOT NULL,
    node_ref character varying(255) DEFAULT NULL::character varying
);



CREATE TABLE public.nodes_transits (
    id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    to_conveyor_id integer NOT NULL,
    to_node_id character(24) NOT NULL,
    prioritet smallint,
    convert text,
    description character varying(255)
);



CREATE SEQUENCE public.nodes_transits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.nodes_transits_id_seq OWNED BY public.nodes_transits.id;



CREATE TABLE public.register_stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    key character varying(100) NOT NULL,
    value numeric(50,5) NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.stream_counters (
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    ts integer NOT NULL,
    in_count integer NOT NULL,
    out_count integer NOT NULL,
    period integer NOT NULL
);



CREATE TABLE public.stream_counters2 (
    conveyor_id integer,
    node_id character(24),
    ts integer,
    in_count integer,
    out_count integer,
    period integer
);



CREATE TABLE public.tasks (
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
    dynamic_timer integer DEFAULT 0 NOT NULL,
    encrypted_data bytea
);



CREATE TABLE public.tasks_archive (
    id bigint NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    create_time integer DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    change_time integer DEFAULT (date_part('epoch'::text, now()))::integer,
    node_id character(24) NOT NULL,
    node_prev_id character(24),
    data text,
    task_id character(24),
    encrypted_data bytea
);



CREATE SEQUENCE public.tasks_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tasks_archive_id_seq OWNED BY public.tasks_archive.id;



CREATE TABLE public.tasks_attrs (
    task_id character(24) NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL
);



CREATE TABLE public.tasks_history (
    id bigint NOT NULL,
    task_id character(24) NOT NULL,
    reference character varying(255),
    conveyor_id integer NOT NULL,
    conveyor_prev_id integer,
    node_id character(24) NOT NULL,
    user_id integer,
    create_time bigint DEFAULT (date_part('epoch'::text, now()))::integer NOT NULL,
    node_prev_id character(24),
    status integer DEFAULT 1 NOT NULL,
    data text,
    prev_id integer DEFAULT 0,
    encrypted_data bytea
);



CREATE SEQUENCE public.tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.tasks_history_id_seq OWNED BY public.tasks_history.id;



CREATE TABLE public.user_group_privilegies (
    id integer NOT NULL,
    group_id integer NOT NULL,
    conveyor_id integer NOT NULL,
    node_id character(24) NOT NULL,
    type smallint NOT NULL,
    prioritet smallint
);



CREATE SEQUENCE public.user_group_privilegies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.user_group_privilegies_id_seq OWNED BY public.user_group_privilegies.id;



ALTER TABLE ONLY public.node_commits_history ALTER COLUMN id SET DEFAULT nextval('public.node_commits_history_id_seq'::regclass);



ALTER TABLE ONLY public.nodes_transits ALTER COLUMN id SET DEFAULT nextval('public.nodes_transits_id_seq'::regclass);



ALTER TABLE ONLY public.tasks_archive ALTER COLUMN id SET DEFAULT nextval('public.tasks_archive_id_seq'::regclass);



ALTER TABLE ONLY public.tasks_history ALTER COLUMN id SET DEFAULT nextval('public.tasks_history_id_seq'::regclass);



ALTER TABLE ONLY public.user_group_privilegies ALTER COLUMN id SET DEFAULT nextval('public.user_group_privilegies_id_seq'::regclass);



ALTER TABLE ONLY public.backup_stream_counters
    ADD CONSTRAINT backup_pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);



ALTER TABLE ONLY public.charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.node_commits_history
    ADD CONSTRAINT node_commits_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.nodes_transits
    ADD CONSTRAINT nodes_transits_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.conveyor_params_access
    ADD CONSTRAINT pk_conveyor_params_access PRIMARY KEY (from_conveyor_id, to_conveyor_id, ts, user_id);



ALTER TABLE ONLY public.register_stream_counters
    ADD CONSTRAINT pk_register_stream_counters PRIMARY KEY (conveyor_id, node_id, ts, key);



ALTER TABLE ONLY public.stream_counters
    ADD CONSTRAINT pk_stream_counters PRIMARY KEY (conveyor_id, node_id, ts);



ALTER TABLE ONLY public.tasks_archive
    ADD CONSTRAINT tasks_archive_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.user_group_privilegies
    ADD CONSTRAINT user_group_privilegies_pkey PRIMARY KEY (id);



CREATE INDEX charts_dashboard_id ON public.charts USING btree (dashboard_id);



CREATE INDEX charts_id_dashboard_id ON public.charts USING btree (id, dashboard_id);



CREATE INDEX conv_id_version_create_time ON public.node_commits_history USING btree (conveyor_id, version, create_time);



CREATE UNIQUE INDEX conveyor_id_node_ref ON public.nodes USING btree (conveyor_id, node_ref);



CREATE INDEX nodes_conveyor_id ON public.nodes USING btree (conveyor_id);



CREATE INDEX nodes_conveyor_id_type ON public.nodes USING btree (conveyor_id, type);



CREATE UNIQUE INDEX nodes_transits_conveyor_id_to_conveyor_id_node_id_to_node_id ON public.nodes_transits USING btree (conveyor_id, to_conveyor_id, node_id, to_node_id);



CREATE UNIQUE INDEX only_one_start_node_constraint ON public.nodes USING btree (conveyor_id, type) WHERE (type = 1);



CREATE INDEX tasks_archive_change_time ON public.tasks_archive USING btree (change_time);



CREATE INDEX tasks_archive_conveyor_id_node_id_change_time ON public.tasks_archive USING btree (conveyor_id, node_id, change_time) WHERE (node_id IS NOT NULL);



CREATE INDEX tasks_archive_conveyor_id_reference ON public.tasks_archive USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);



CREATE INDEX tasks_archive_conveyor_id_task_id ON public.tasks_archive USING btree (conveyor_id, task_id) WHERE (task_id IS NOT NULL);



CREATE INDEX tasks_attrs_task_id ON public.tasks_attrs USING btree (task_id);



CREATE INDEX tasks_conveyor_id_node_id_status ON public.tasks USING btree (conveyor_id, node_id, status);



CREATE UNIQUE INDEX tasks_conveyor_id_reference ON public.tasks USING btree (conveyor_id, reference) WHERE (reference IS NOT NULL);



CREATE INDEX tasks_history_conveyor_id_create_time ON public.tasks_history USING btree (conveyor_id, create_time);



CREATE INDEX tasks_history_conveyor_id_reference ON public.tasks_history USING btree (conveyor_id, reference);



CREATE INDEX tasks_history_conveyor_id_task_id_create_time ON public.tasks_history USING btree (conveyor_id, task_id, create_time);



CREATE INDEX tasks_node_id_change_time ON public.tasks USING btree (node_id, change_time);



CREATE INDEX tasks_node_id_dynamic_timer ON public.tasks USING btree (node_id, dynamic_timer);



