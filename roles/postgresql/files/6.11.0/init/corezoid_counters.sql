

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



CREATE FUNCTION public.fn_del_counter_v1(input_key text, input_write_lock text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    lock_info TEXT;
    lock_expired BOOLEAN;
    rows_deleted INTEGER;
BEGIN
    -- Проверка write_lock с учетом ttl и времени
    SELECT who_locked, now() > locked_at + ttl AS is_expired
    INTO lock_info, lock_expired
    FROM counters_locks
    WHERE lock_key = input_write_lock;

    -- Если блокировка активна, возвращаем информацию о блокировке
    IF lock_info IS NOT NULL AND NOT lock_expired THEN
        RETURN jsonb_build_object(
            'status', 'ERR',
            'msg', 'write_lock by ' || lock_info
        );
    END IF;

    -- Удаление записей из таблицы counters
    DELETE FROM node_counters
    WHERE key = input_key;

    -- Получение количества удаленных строк
    GET DIAGNOSTICS rows_deleted = ROW_COUNT;

    -- Возврат успешного результата
    RETURN jsonb_build_object(
        'status', 'OK',
        'rows_deleted', rows_deleted
    );
END;
$$;



CREATE FUNCTION public.fn_incr_counter_with_threshold_v1(input_key text, input_field text, increment_value integer, input_thresholds jsonb, input_op_ref text, input_lock_key text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    variable_counter_id INTEGER;
    updated_value INTEGER;
    current_threshold INTEGER;
    threshold_results JSONB := '[]'::JSONB;
    existing_result JSONB;
    lock_info TEXT;
    lock_expired BOOLEAN;
BEGIN

    -- Проверка на существующую запись в op_log
    SELECT result INTO existing_result
    FROM node_counters_operation_logs
    WHERE op_ref = input_op_ref;

    IF existing_result IS NOT NULL THEN
        -- Если запись уже существует, возвращаем её
        RETURN existing_result;
    END IF;

    -- Проверка на наличие блокировки
    SELECT who_locked, now() > locked_at + ttl AS is_expired
    INTO lock_info, lock_expired
    FROM counters_locks
    WHERE lock_key = input_lock_key;

    IF lock_info IS NOT NULL AND NOT lock_expired THEN
        -- Если блокировка активна, возвращаем статус блокировки
        RETURN jsonb_build_object(
            'status', 'ERR',
            'msg', 'write_lock by ' || lock_info
        );
    END IF;

    -- Получение идентификатора счетчика
    SELECT id INTO variable_counter_id
    FROM node_counters
    WHERE node_counters.key = input_key AND node_counters.field = input_field;

    IF variable_counter_id IS NULL THEN
        -- Если счетчик не существует, создаем его
        INSERT INTO node_counters (key, field, value)
        VALUES (input_key, input_field, 0)
        RETURNING id INTO variable_counter_id;
    END IF;

    -- Увеличение значения счетчика
    UPDATE node_counters
    SET value = value + increment_value
    WHERE id = variable_counter_id
    RETURNING value INTO updated_value;

    -- Проверка порогов
    IF input_thresholds <> '[]'::JSONB THEN
        FOR current_threshold IN SELECT jsonb_array_elements_text(input_thresholds)::INTEGER LOOP
            IF updated_value >= current_threshold THEN
                -- Если порог превышен и запись отсутствует, добавляем эскалацию
                IF NOT EXISTS (
                    SELECT 1
                    FROM node_counters_escalation_thresholds
                    WHERE node_counters_escalation_thresholds.counter_id = variable_counter_id
                          AND node_counters_escalation_thresholds.threshold = current_threshold
                ) THEN
                    INSERT INTO node_counters_escalation_thresholds (counter_id, threshold)
                    VALUES (variable_counter_id, current_threshold);

                    -- Добавляем результат в JSON
                    threshold_results := threshold_results || jsonb_build_object(current_threshold, '1');
                END IF;
            ELSE
                -- Если значение ниже порога, удаляем активную эскалацию
                IF EXISTS (
                    SELECT 1
                    FROM node_counters_escalation_thresholds
                    WHERE node_counters_escalation_thresholds.counter_id = variable_counter_id
                          AND node_counters_escalation_thresholds.threshold = current_threshold
                ) THEN
                    DELETE FROM node_counters_escalation_thresholds
                    WHERE node_counters_escalation_thresholds.counter_id = variable_counter_id
                          AND node_counters_escalation_thresholds.threshold = current_threshold;

                    -- Добавляем результат в JSON
                    threshold_results := threshold_results || jsonb_build_object(current_threshold, '0');
                END IF;
            END IF;
        END LOOP;
    END IF;

    -- Формируем результат
    existing_result := jsonb_build_object(
        'status', 'OK',
        'value', updated_value,
        'thresholds', threshold_results
    );

    -- Логируем операцию
    INSERT INTO node_counters_operation_logs (op_ref, counter_id, result)
    VALUES (input_op_ref, variable_counter_id, existing_result);

    -- Возвращаем результат
    RETURN existing_result;
END;
$$;



CREATE FUNCTION public.fn_increment_api_sum_v1(input_node_key text, input_sub_key text, input_value numeric, input_write_lock text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    lock_info TEXT;
    lock_expired BOOLEAN;
    new_value NUMERIC;
BEGIN
    SELECT who_locked, now() > locked_at + ttl AS is_expired
    INTO lock_info, lock_expired
    FROM counters_locks
    WHERE lock_key = input_write_lock;

    IF lock_info IS NOT NULL AND NOT lock_expired THEN
        RETURN jsonb_build_object(
            'status', 'ERR',
            'msg', 'write_lock by ' || lock_info
        );
    END IF;

    INSERT INTO api_sum_logic_counters (node_key, sub_key, value)
    VALUES (input_node_key, input_sub_key, input_value)
    ON CONFLICT (node_key, sub_key)
    DO UPDATE SET value = api_sum_logic_counters.value + EXCLUDED.value
    RETURNING api_sum_logic_counters.value INTO new_value;

    RETURN jsonb_build_object(
        'status', 'OK',
        'value', new_value
    );
END;
$$;



CREATE FUNCTION public.fn_remove_keys_v1(input_node_key text, input_write_lock text DEFAULT NULL::text, input_keys text[] DEFAULT NULL::text[]) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    lock_info TEXT;
    lock_expired BOOLEAN;
BEGIN
    -- Проверка write_lock с учётом ttl и времени
    SELECT who_locked, now() > locked_at + ttl AS is_expired
    INTO lock_info, lock_expired
    FROM counters_locks
    WHERE lock_key = input_write_lock;

    -- Если блокировка активна, возвращаем информацию о блокировке
    IF lock_info IS NOT NULL AND NOT lock_expired THEN
        RETURN jsonb_build_object(
            'status', 'ERR',
            'msg', 'write_lock by ' || lock_info
        );
    END IF;

    -- Удаление всех ключей, если список ключей пуст
    IF input_keys IS NULL THEN
        DELETE FROM api_sum_logic_counters
        WHERE node_key = input_node_key;
    ELSE
        -- Удаление ключей, не входящих в список
        DELETE FROM api_sum_logic_counters
        WHERE node_key = input_node_key AND sub_key <> ALL(input_keys);
    END IF;

    -- Возврат успешного результата
    RETURN jsonb_build_object(
        'status', 'OK',
        'keys_deleted', COALESCE(array_length(input_keys, 1), 0)
    );
END;
$$;



CREATE FUNCTION public.fn_set_or_extend_lock_v1(income_lock_key text, income_worker_id text, income_ttl interval) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_worker_id TEXT;
    current_locked_at TIMESTAMP;
BEGIN
    SELECT who_locked, locked_at
    INTO current_worker_id, current_locked_at
    FROM counters_locks
    WHERE lock_key = income_lock_key;

    IF current_worker_id IS NULL THEN
        INSERT INTO counters_locks (lock_key, who_locked, locked_at, ttl)
        VALUES (income_lock_key, income_worker_id, now(), income_ttl)
        ON CONFLICT (lock_key)
        DO UPDATE SET
            who_locked = EXCLUDED.who_locked,
            locked_at = now(),
            ttl = EXCLUDED.ttl;

        RETURN jsonb_build_object(
            'status', 'OK',
            'msg', 'lock_created'
        );
    ELSIF current_worker_id = income_worker_id THEN
        UPDATE counters_locks
        SET locked_at = now(), ttl = income_ttl
        WHERE lock_key = income_lock_key;

        RETURN jsonb_build_object(
            'status', 'OK',
            'msg', 'lock_extended'
        );
    ELSE
        RETURN jsonb_build_object(
            'status', 'ERR',
            'msg', 'locked_by ' || current_worker_id
        );
    END IF;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.api_sum_logic_counters (
    node_key text NOT NULL,
    sub_key text NOT NULL,
    value double precision DEFAULT 0.0
);



CREATE TABLE public.counters_locks (
    lock_key text NOT NULL,
    who_locked text NOT NULL,
    locked_at timestamp without time zone DEFAULT now(),
    ttl interval NOT NULL
);



CREATE TABLE public.node_counters (
    id integer NOT NULL,
    key text NOT NULL,
    field text NOT NULL,
    value integer DEFAULT 0
);



CREATE TABLE public.node_counters_escalation_thresholds (
    id integer NOT NULL,
    counter_id integer NOT NULL,
    threshold integer NOT NULL
);



CREATE SEQUENCE public.node_counters_escalation_thresholds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.node_counters_escalation_thresholds_id_seq OWNED BY public.node_counters_escalation_thresholds.id;



CREATE SEQUENCE public.node_counters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.node_counters_id_seq OWNED BY public.node_counters.id;



CREATE TABLE public.node_counters_operation_logs (
    op_ref text NOT NULL,
    counter_id integer NOT NULL,
    result jsonb,
    created_at timestamp without time zone DEFAULT now()
);



ALTER TABLE ONLY public.node_counters ALTER COLUMN id SET DEFAULT nextval('public.node_counters_id_seq'::regclass);



ALTER TABLE ONLY public.node_counters_escalation_thresholds ALTER COLUMN id SET DEFAULT nextval('public.node_counters_escalation_thresholds_id_seq'::regclass);



ALTER TABLE ONLY public.api_sum_logic_counters
    ADD CONSTRAINT api_sum_logic_counters_pkey PRIMARY KEY (node_key, sub_key);



ALTER TABLE ONLY public.node_counters
    ADD CONSTRAINT counters_key_field_key UNIQUE (key, field);



ALTER TABLE ONLY public.counters_locks
    ADD CONSTRAINT counters_locks_pkey PRIMARY KEY (lock_key);



ALTER TABLE ONLY public.node_counters_escalation_thresholds
    ADD CONSTRAINT escalation_thresholds_counter_id_threshold_key UNIQUE (counter_id, threshold);



ALTER TABLE ONLY public.node_counters_escalation_thresholds
    ADD CONSTRAINT node_counters_escalation_thresholds_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.node_counters_operation_logs
    ADD CONSTRAINT node_counters_operation_logs_pkey PRIMARY KEY (op_ref);



ALTER TABLE ONLY public.node_counters
    ADD CONSTRAINT node_counters_pkey PRIMARY KEY (id);



CREATE INDEX idx_api_sum_logic_counters_node_key ON public.api_sum_logic_counters USING btree (node_key);



ALTER TABLE ONLY public.node_counters_escalation_thresholds
    ADD CONSTRAINT node_counters_escalation_thresholds_counter_id_fkey FOREIGN KEY (counter_id) REFERENCES public.node_counters(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.node_counters_operation_logs
    ADD CONSTRAINT node_counters_operation_logs_counter_id_fkey FOREIGN KEY (counter_id) REFERENCES public.node_counters(id) ON DELETE CASCADE;



