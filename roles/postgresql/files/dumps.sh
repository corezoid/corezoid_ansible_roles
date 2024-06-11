#!/bin/bash
DBNAMES=$(echo cp{0..9})

[ ! -z "${DBNAMES}" ] || { echo "ERROR :: DBNAMES not defined"; exit 1; }

TABLES="charts conveyor_params_access node_commits_history nodes nodes_transits register_stream_counters stream_counters tasks user_group_privilegies "
PGARGS="--port 5433"

DUMPS="/var/lib/pgsql/9.6/backups"
PG_DUMP=$(which pg_dump)
PSQL=$(which psql)
GZIP=$(which gzip)
PIGZ=$(which pigz)

check_database(){
    [ "${1}" ] || exit 1
    CHECKDB=$(${PSQL} ${PGARGS} -Atc "SELECT datname FROM pg_database where datname = '${1}'")
    [ ! -z "${CHECKDB}" ] || { echo "Database ${1} does not exist..."; exit 1; }
}

dump_shards(){
    for DBNAME in ${DBNAMES}
    do
        nice -n19 ionice -c3 ${PG_DUMP} ${PGARGS} -s ${DBNAME} -f ${DUMPS}/${DBNAME}_schema.sql || { echo "Dump schema for ${DBNAME} failed"; exit 1; }
        dump_tables
    done
}

dump_tables(){
    [ -d "${DUMPS}" ] && [ -e "${PG_DUMP}" ] || exit 1
    for TABLE in ${TABLES}
    do
        nice -n19 ionice -c3 ${PG_DUMP} ${PGARGS} -Cc -t ${TABLE} ${DBNAME} -f ${DUMPS}/${DBNAME}.${TABLE}.sql || { echo "Dump data for ${TABLE} in ${DBNAME} failed"; exit 1; }
        nice -n19 ionice -c3 ${PIGZ} -9 -f ${DUMPS}/${DBNAME}.${TABLE}.sql || { echo "Unable to compress file: ${DUMPS}/${DBNAME}.${TABLE}.sql"; exit 1; }
    done
}

dump_database(){
    check_database "${1}"
    nice -n19 ionice -c3 ${PG_DUMP} ${PGARGS} -Cc ${1} --exclude-table=conveyor_billing --exclude-table=conveyor_called_timers --exclude-table=cce_exec_time -f ${DUMPS}/${1}.sql || { echo "Dump data for ${DBNAME} failed"; exit 1; }
    nice -n19 ionice -c3 ${PG_DUMP} ${PGARGS} -s ${1} -f ${DUMPS}/${1}_schema.sql || { echo "Dump schema for ${DBNAME} failed"; exit 1; }

    nice -n19 ionice -c3 ${PIGZ} -9 -f ${DUMPS}/${1}.sql || { echo "Unable to compress file: ${DUMPS}/${1}.sql"; exit 1; }
    nice -n19 ionice -c3 ${PIGZ} -9 -f ${DUMPS}/${1}_schema.sql || { echo "Unable to compress file: ${DUMPS}/${1}.sql"; exit 1; }
}

case ${1} in
    shards)
        dump_shards
        exit 0
        ;;
    conveyor|cce)
        dump_database "${1}"
        exit 0
        ;;
    all_main)
        dump_database "cce"
        dump_database "conveyor"
        # dump_database "conveyor_statistics"
        exit 0
        ;;
    all)
        dump_database "cce"
        dump_database "conveyor"
        dump_shards
        exit 0
        ;;
    *)
        echo "Usage: ${0} all | shards | conveyor | cce | all_main" && exit 1
esac
