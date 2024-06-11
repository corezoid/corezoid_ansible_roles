#!/bin/bash
PATH=${PATH}:/usr/pgsql-9.6/bin

#PGARGS="--port 5433 -h POSTGRES_RDS_ENDPOINT_CF"
PGARGS="--port 5433"
#PGARGS2="-p 5433  -h POSTGRES_RDS_ENDPOINT_CF"
PGARGS2="-p 5433"
DBNAMES=$(cd /tmp && psql -d postgres -p 5433 -t -c "SELECT datname FROM pg_database;" | grep cp[0-9]*)

PG_BIN_PATH="/usr/pgsql-9.6/bin"
PG_DATA="/var/lib/pgsql/9.6/data/base"
SCRIPTS="/var/lib/pgsql/scripts"

R_LOG="${SCRIPTS}/reglament.log"

cd ${SCRIPTS} || exit 1

check_exist_pgdb(){
    local DB
    DB="$1"
    nohup 1>/dev/null 2>/dev/null psql ${PGARGS} ${DB} -c 'select 1' || { echo "connection to ${DB} failed"; exit 1; }
}

truncate_all(){
    for DBNAME in ${DBNAMES}
    do
        WRAP_PID=$(psql ${PGARGS} -Atc "select pid from pg_stat_activity where datname = '${DBNAME}' and query = 'autovacuum: VACUUM public.tasks_archive (to prevent wraparound)'")
        [ -z "${WRAP_PID}" ] || { psql ${PGARGS} -c "select pg_cancel_backend(${WRAP_PID})"; }
        echo -n "${DBNAME} "
        psql ${PGARGS} ${DBNAME} -c "TRUNCATE tasks_archive"
    done
    for DBNAME in ${DBNAMES}
    do
        WRAP_PID=$(psql ${PGARGS} -Atc "select pid from pg_stat_activity where datname = '${DBNAME}' and query = 'autovacuum: VACUUM public.tasks_history (to prevent wraparound)'")
        [ -z "${WRAP_PID}" ] || { psql ${PGARGS} -c "select pg_cancel_backend(${WRAP_PID})"; }
        echo -n "${DBNAME} "
        psql ${PGARGS} ${DBNAME} -c "TRUNCATE tasks_history"
    done
}


check_bloat_tables(){
    for DBNAME in ${DBNAMES}
    do
	psql -p 5433 -d ${DBNAME} -Atc "CREATE EXTENSION pgstattuple" >/dev/null 2>&1
        check_exist_pgdb "${DBNAME}"
        #TABLES=$(psql ${PGARGS} ${DBNAME} -Atc "SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
        TABLES="tasks"
        for TABLE in ${TABLES}
        do
            echo "${DBNAME}|${TABLE}|$(psql ${PGARGS} ${DBNAME} -Atc "SELECT free_percent FROM pgstattuple('${TABLE}')")"
        done
    done
}

repack_shards(){
    local ${TABLE}
    TABLE="$1"
    for DBNAME in ${DBNAMES}
    do
	echo "==============Don't stop this operation! Please wait for the finish line!=============="
        check_exist_pgdb "${DBNAME}"
	psql -p 5433 -d ${DBNAME} -Atc "CREATE EXTENSION pg_repack" >/dev/null 2>&1
        WRAP_PID=$(psql ${PGARGS} -Atc "select pid from pg_stat_activity where datname = '${DBNAME}' and query = 'autovacuum: VACUUM public.tasks (to prevent wraparound)'")
        [ -z "${WRAP_PID}" ] || { psql ${PGARGS} -c "select pg_cancel_backend(${WRAP_PID})"; }

        echo "Running pg_repack for tasks in ${DBNAME}"
        pg_repack ${PGARGS2} -d ${DBNAME} --table ${TABLE} || exit 1
        echo "==============Finish!=============="
    done
}

dbsize(){
    psql ${PGARGS} -Atc "\l+" | awk -F\| '{print $1" "$7}' | egrep -v "template|postgres"
}

top_tables() {
    if [ ! -z "${1}" ]; then
        DB=${1}
    else
        echo "ERROR :: Database not defined"
        exit 1
    fi
    [ ! -z "${SCHEMA}" ] || { SCHEMA='public'; }

    psql ${PGARGS} ${DB} -c "SELECT schemaname,tablename,
        pg_size_pretty(pg_relation_size(schemaname || '.' || tablename)) AS size_p,
        pg_total_relation_size(schemaname || '.' || tablename) AS size,
        pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) AS total_size_p,
        pg_total_relation_size(schemaname || '.' || tablename) - pg_relation_size(schemaname || '.' || tablename) AS index_size,
        (100*(pg_total_relation_size(schemaname || '.' || tablename) - pg_relation_size(schemaname || '.' || tablename)))/CASE WHEN pg_total_relation_size(schemaname || '.' || tablename) = 0 THEN 1 ELSE pg_total_relation_size(schemaname || '.' || tablename) END || '%' AS index_pct FROM pg_tables where schemaname = '${SCHEMA}' ORDER BY size DESC LIMIT 20"
}

top_db_tab() {
        DB=$(for DB in $(psql -d postgres -p 5433 -t -c "SELECT datname FROM pg_database;" | grep cp[0-9]*); do echo "${DB}"; done)
    for DBNAME in ${DB}
    do
    echo "TOP TABLE IN ${DBNAME}:"
    psql ${PGARGS} ${DBNAME} -c "SELECT schemaname,tablename,
        pg_size_pretty(pg_relation_size(schemaname || '.' || tablename)) AS size_p,
        pg_total_relation_size(schemaname || '.' || tablename) AS size,
        pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) AS total_size_p,
        pg_total_relation_size(schemaname || '.' || tablename) - pg_relation_size(schemaname || '.' || tablename) AS index_size,
        (100*(pg_total_relation_size(schemaname || '.' || tablename) - pg_relation_size(schemaname || '.' || tablename)))/CASE WHEN pg_total_relation_size(schemaname || '.' || tablename) = 0 THEN 1 ELSE pg_total_relation_size(schemaname || '.' || tablename) END || '%' AS index_pct FROM pg_tables where schemaname = 'public' ORDER BY size DESC LIMIT 5"
    done
}

top_process_by_tacts() {
    echo " conveyor_id | user_id |        date         | opers | tacts | traff"
    psql ${PGARGS} -d conveyor -t -c "SELECT conveyor_id, user_id, to_char(date_trunc('hour', to_timestamp(ts)), 'YYYY-MM-DD HH24:00:00') AS date, SUM(opers_count) as opers, SUM(tacts_count) as tacts, trunc(SUM(tasks_bytes_size)/(1024*1024), 2) as traff FROM conveyor_billing WHERE ts >= extract(epoch from now() - interval '20 minutes')::integer and ts <= extract(epoch from now() - interval '1 minutes')::integer GROUP by conveyor_id, user_id, date ORDER BY tacts DESC LIMIT 20"
}

top_process_by_traff() {
    echo " conveyor_id | user_id |        date         | opers | tacts | traff"
    psql ${PGARGS} -d conveyor -t -c "SELECT conveyor_id, user_id, to_char(date_trunc('hour', to_timestamp(ts)), 'YYYY-MM-DD HH24:00:00') AS date, SUM(opers_count) as opers, SUM(tacts_count) as tacts, trunc(SUM(tasks_bytes_size)/(1024*1024), 2) as traff FROM conveyor_billing WHERE ts >= extract(epoch from now() - interval '20 minutes')::integer and ts <= extract(epoch from now() - interval '1 minutes')::integer GROUP by conveyor_id, user_id, date ORDER BY traff DESC LIMIT 20"
}

top_process_by_opers() {
    echo " conveyor_id | user_id |        date         | opers | tacts | traff"
    psql ${PGARGS} -d conveyor -t -c "SELECT conveyor_id, user_id, to_char(date_trunc('hour', to_timestamp(ts)), 'YYYY-MM-DD HH24:00:00') AS date, SUM(opers_count) as opers, SUM(tacts_count) as tacts, trunc(SUM(tasks_bytes_size)/(1024*1024), 2) as traff FROM conveyor_billing WHERE ts >= extract(epoch from now() - interval '20 minutes')::integer and ts <= extract(epoch from now() - interval '1 minutes')::integer GROUP by conveyor_id, user_id, date ORDER BY opers DESC LIMIT 20"
}

case "$1" in
    truncate_all)
        truncate_all
    ;;
    check_bloat)
        check_bloat_tables
    ;;
    repack_shards)
        repack_shards "tasks"
    ;;
    dbsize)
        dbsize
    ;;
    top)
        top_tables "$2"
    ;;
    top_db)
        top_db_tab
    ;;
    top_proc_by_tacts)
	      top_process_by_tacts
    ;;
    top_proc_by_traff)
        top_process_by_traff
    ;;
    top_proc_by_opers)
        top_process_by_opers
    ;;
	*)
	echo "Usage: ${0} { truncate_all | check_bloat | repack_shards | dbsize | top | top_db | top_proc_by_tacts | top_proc_by_opers | top_proc_by_traff }"

esac
