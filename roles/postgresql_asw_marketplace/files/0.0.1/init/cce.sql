

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE TYPE public.cce_src_lang AS ENUM (
    'erl',
    'js',
    'lua'
);



CREATE FUNCTION public.blocked_last_hour(p_from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_from_hour integer DEFAULT NULL::integer, p_to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_to_hour integer DEFAULT NULL::integer, p_is_ignore_advisory boolean DEFAULT true, OUT host_name text, OUT total_time_ss bigint, OUT threads_count bigint, OUT incidents_count bigint, OUT blocked_query text, OUT one_blocking_query text) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
  i			integer;
BEGIN

  if (p_to_date IS NULL  OR  p_from_date IS NULL) then
     p_to_date := current_date;
     p_to_hour := extract (hour from current_time);
  end if;

  if (p_from_date IS NULL) then
     p_from_hour := extract (hour from current_time);
     if (p_from_hour = 0) then
        p_from_hour := 23;
        p_from_date := current_date - interval '1 day';
     else
        p_from_hour := p_from_hour -1;
        p_from_date := current_date;
     end if;
  end if;

  if (p_from_hour IS NULL) then
     p_from_hour = 0;
  end if;
  if (p_to_hour iS NULL) then
     p_to_hour = p_from_hour;
  end if;

  p_from_date = p_from_date + (p_from_hour * interval '1 hour');
  p_to_date = p_to_date + (p_to_hour * interval '1 hour');

  --raise notice '%,%',p_from_date, p_to_date;

  RETURN QUERY
	with t as
	(
	  select
		min (blocked.bl_host_id) host_id,
		min (blocked.bl_timestamp) start_time,
		max (blocked.bl_timestamp) end_time,
		extract ( seconds from (max(blocked.bl_timestamp) - min (blocked.bl_timestamp)) )::integer delta_time,
		blocked.pid blocked_pid,
		blocking.pid blocking_pid,
		blocked.relation,
		blockedp.query blocked_query,
		blockingp.query blocking_query
	  from blocking_locks blocked
	 inner join blocking_locks blocking
		   on (  (blocked.transactionid is not null and blocked.transactionid = blocking.transactionid)
		       or (blocked.virtualxid is not null and blocked.virtualxid = blocking.virtualxid)
		       or (blocked.classid is not null and blocked.classid  = blocking.classid and blocked.objid = blocking.objid and blocked.objsubid = blocking.objsubid)
		       or (blocked.database is not null and blocked.database = blocking.database and blocked.relation = blocking.relation)
		      )
		   and blocked.pid != blocking.pid
		   and blocked.bl_timestamp = blocking.bl_timestamp
		   and blocked.bl_host_id = blocking.bl_host_id
	  inner join blocking_processes blockedp
	     on blockedp.pid = blocked.pid
	    and blockedp.bp_host_id = blocked.bl_host_id
	    and blockedp.bp_timestamp = blocked.bl_timestamp
	  inner join blocking_processes blockingp
	     on blockingp.pid = blocking.pid
	    and blockingp.bp_host_id = blocking.bl_host_id
	    and blockingp.bp_timestamp = blocking.bl_timestamp
	  where NOT blocked.granted and blocking.granted
		and blocked.bl_timestamp between p_from_date and p_to_date
		and blocking.bl_timestamp between p_from_date and p_to_date
		and blockedp.bp_timestamp between p_from_date and p_to_date
		and blockingp.bp_timestamp between p_from_date and p_to_date
	  group by blocked.pid, blocking.pid, blocked.relation,
		blockedp.query, blockingp.query
	)

	select 	hosts.host_name,
		sum(delta_time) total_time_ss,
		sum(threads_blocked)::bigint threads_count,
		count(1)::bigint incidents_count,
		a.blocked_query,
		max(a.blocking_query) blocking_query
	from
	(
	 select
		t1.host_id,
		t1.start_time,
		t1.delta_time,
		count(distinct t1.blocked_pid) threads_blocked,
		t1.blocking_pid,
		t1.relation,
		t1.blocked_query, max(t1.blocking_query) blocking_query,

	case when exists (select 1 from t t2 where t1.blocking_pid = t2.blocked_pid and

		   (   t1.start_time between t2.start_time and t2.end_time
		    or t1.end_time between t2.start_time and t2.end_time
		    or (t1.start_time < t2.start_time and t1.end_time > t2.end_time)
		   )
		) then true else false
		end as is_blocked
	from t as t1

	where t1.start_time != t1.end_time
	group by t1.host_id, t1.start_time, t1.delta_time, t1.blocking_pid, t1.relation,
		t1.blocked_query,
	case when exists (select 1 from t t2 where t1.blocking_pid = t2.blocked_pid and
		   (   t1.start_time between t2.start_time and t2.end_time
		    or t1.end_time between t2.start_time and t2.end_time
		    or (t1.start_time < t2.start_time and t1.end_time > t2.end_time)
		   )
		) then true else false
		end
	having max(t1.blocked_query) != 'select schemaname%'
	order by t1.start_time desc, is_blocked desc

	) a
        inner join hosts
           on hosts.host_id = a.host_id
	where not is_blocked
	and a.blocked_query not like 'SELECT schemaname%'  --PGObserver
	and (NOT p_is_ignore_advisory OR a.blocked_query not like 'select pg_advisory_lock%')
	and a.blocked_query not like 'CREATE %INDEX %CON%'  -- expected and fine
	and a.blocked_query not like 'create %index %con%'  -- expected and fine
	and a.blocked_query not like 'DROP INDEX %CON%' --  expected and fine
	group by hosts.host_name,
		a.blocked_query
	order by 2 desc;

END;
$$;



CREATE FUNCTION public.blocking_last_day(p_from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_is_ignore_advisory boolean DEFAULT true, OUT host_name text, OUT total_time_ss bigint, OUT threads_count bigint, OUT incidents_count bigint, OUT blocking_query text, OUT one_blocked_query text) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
  i			integer;
BEGIN

  if (p_from_date IS NULL) then
     p_from_date := current_date - interval '1 day';
  end if;

  if (p_to_date IS NULL) then
     p_to_date := p_from_date + interval '1 day';
  end if;

  raise notice '%,%',p_from_date, p_to_date;


  RETURN QUERY
	with t as
	(
	  select
		min (blocked.bl_host_id) host_id,
		min (blocked.bl_timestamp) start_time,
		max (blocked.bl_timestamp) end_time,
		extract ( seconds from (max(blocked.bl_timestamp) - min (blocked.bl_timestamp)) )::integer delta_time,
		blocked.pid blocked_pid,
		blocking.pid blocking_pid,
		blocked.relation,
		blockedp.query blocked_query,
		blockingp.query blocking_query
	  from blocking_locks blocked
	 inner join blocking_locks blocking
		   on (  (blocked.transactionid is not null and blocked.transactionid = blocking.transactionid)
		       or (blocked.virtualxid is not null and blocked.virtualxid = blocking.virtualxid)
		       or (blocked.classid is not null and blocked.classid  = blocking.classid and blocked.objid = blocking.objid and blocked.objsubid = blocking.objsubid)
		       or (blocked.database is not null and blocked.database = blocking.database and blocked.relation = blocking.relation)
		      )
		   and blocked.pid != blocking.pid
		   and blocked.bl_timestamp = blocking.bl_timestamp
		   and blocked.bl_host_id = blocking.bl_host_id
	  inner join blocking_processes blockedp
	     on blockedp.pid = blocked.pid
	    and blockedp.bp_host_id = blocked.bl_host_id
	    and blockedp.bp_timestamp = blocked.bl_timestamp
	  inner join blocking_processes blockingp
	     on blockingp.pid = blocking.pid
	    and blockingp.bp_host_id = blocking.bl_host_id
	    and blockingp.bp_timestamp = blocking.bl_timestamp
	  where NOT blocked.granted and blocking.granted
		and blocked.bl_timestamp between p_from_date and p_to_date
		and blocking.bl_timestamp between p_from_date and p_to_date
		and blockedp.bp_timestamp between p_from_date and p_to_date
		and blockingp.bp_timestamp between p_from_date and p_to_date
	  group by blocked.pid, blocking.pid, blocked.relation,
		blockedp.query, blockingp.query
	)

	select 	hosts.host_name,
		sum(delta_time) total_time_ss,
		sum(threads_blocked)::bigint threads_count,
		count(1)::bigint incidents_count,
		a.blocking_query,
		max(a.blocked_query) blocked_query
	from
	(
	 select
		t1.host_id,
		t1.start_time,
		t1.delta_time,
		count(distinct t1.blocked_pid) threads_blocked,
		t1.blocking_pid,
		t1.relation,
		t1.blocking_query,
		max(t1.blocked_query) blocked_query,

	case when exists (select 1 from t t2 where t1.blocking_pid = t2.blocked_pid and

		   (   t1.start_time between t2.start_time and t2.end_time
		    or t1.end_time between t2.start_time and t2.end_time
		    or (t1.start_time < t2.start_time and t1.end_time > t2.end_time)
		   )
		) then true else false
		end as is_blocked
	from t as t1

	where t1.start_time != t1.end_time
	group by t1.host_id, t1.start_time, t1.delta_time, t1.blocking_pid, t1.relation,
		t1.blocking_query,
	case when exists (select 1 from t t2 where t1.blocking_pid = t2.blocked_pid and
		   (   t1.start_time between t2.start_time and t2.end_time
		    or t1.end_time between t2.start_time and t2.end_time
		    or (t1.start_time < t2.start_time and t1.end_time > t2.end_time)
		   )
		) then true else false
		end
	having max(t1.blocked_query) != 'select schemaname%'
	order by t1.start_time desc, is_blocked desc

	) a
        inner join hosts
           on hosts.host_id = a.host_id
	where not is_blocked
	and a.blocked_query not like 'SELECT schemaname%'  --PGObserver
	and (NOT p_is_ignore_advisory OR a.blocked_query not like 'select pg_advisory_lock%')
	and a.blocked_query not like 'CREATE %INDEX %CON%'  -- expected and fine
	and a.blocked_query not like 'create %index %con%'  -- expected and fine
	and a.blocked_query not like 'DROP INDEX %CON%' --  expected and fine
	group by hosts.host_name,
		a.blocking_query
	order by 2 desc;

END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE public.cce_src (
    conv text NOT NULL,
    node text NOT NULL,
    src text,
    lang public.cce_src_lang,
    id_pk integer NOT NULL
);



CREATE SEQUENCE public.cce_src_id_pk_seq
    START WITH 1277
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE SEQUENCE public.cce_src_id_pk_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.cce_src_id_pk_seq1 OWNED BY public.cce_src.id_pk;



CREATE TABLE public.cce_src_temp (
    id integer NOT NULL,
    conv text,
    node text,
    src text,
    lang public.cce_src_lang
);



CREATE SEQUENCE public.cce_src_temp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.cce_src_temp_id_seq OWNED BY public.cce_src_temp.id;



ALTER TABLE ONLY public.cce_src ALTER COLUMN id_pk SET DEFAULT nextval('public.cce_src_id_pk_seq1'::regclass);



ALTER TABLE ONLY public.cce_src_temp ALTER COLUMN id SET DEFAULT nextval('public.cce_src_temp_id_seq'::regclass);



ALTER TABLE ONLY public.cce_src_temp
    ADD CONSTRAINT cce_src_temp_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.cce_src
    ADD CONSTRAINT my_index PRIMARY KEY (conv, node);



CREATE UNIQUE INDEX conv_node_cce_src_temp ON public.cce_src_temp USING btree (conv, node);



