#!/bin/bash

DBNAMES="conveyor"

TABLES="users logins login_to_users oauth2_access oauth2_client_groups oauth2_clients oauth2_clients_to_groups oauth2_history oauth2_scopes oauth2_tokens single_account_api_keys user_to_2fa"

PGARGS="--port 5433"

DEST_DB="accounts"

PG_DUMP="/usr/pgsql-9.6/bin/pg_dump"
PSQL="/usr/pgsql-9.6/bin/psql"

check_database(){
    [ "${1}" ] || exit 1
    CHECKDB=$(${PSQL} ${PGARGS} -Atc "SELECT datname FROM pg_database where datname = '${1}'")
    [ ! -z "${CHECKDB}" ] || { ${PSQL} ${PGARGS} -Atc "CREATE DATABASE ${1};"; echo "Database ${1} created ..."; }
}

dump_shards(){
    for DBNAME in ${DBNAMES}
    do
        check_database "${DBNAME}"
        check_database "${DEST_DB}"
        dump_tables
    done
}

dump_tables(){
    [ -e "${PG_DUMP}" ] || exit 1
    for TABLE in ${TABLES}
    do
        echo "Dump and copy ${TABLE} from ${DBNAME} to ${DEST_DB} ..."
        ${PG_DUMP} ${PGARGS} -Cc -t ${TABLE} ${DBNAME} | ${PSQL} ${PGARGS} -d ${DEST_DB}
    done
}


case ${1} in
    all)
        dump_shards
        ;;
    *)
        echo "Usage: ${0} all"
esac
