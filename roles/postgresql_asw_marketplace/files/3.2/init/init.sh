#!/bin/bash

PGPASS_FILE="/root/.pgpass"

echo "POSTGRES_RDS_ENDPOINT:5432:*:internal_user:internal_user" > ${PGPASS_FILE}

chmod 0600 ${PGPASS_FILE}

/usr/bin/psql -h POSTGRES_RDS_ENDPOINT -U internal_user < /root/init/create_db.sql

/usr/bin/psql -h POSTGRES_RDS_ENDPOINT -U internal_user < /root/init/create_rols.sql
