#!/bin/bash
#PGARGS="-p 5433 -U internal_user"
PGARGS="-p 5433"

read -p "Enter login: " MANUAL_INPUT_1

#user_login=$( echo ${MANUAL_INPUT_1} | sed -e 's'/[^A-Za-z@_.-]//g)
user_login=${MANUAL_INPUT_1}

#AUTH_HASH=$(sed -n -e 's/^\([[:space:]]*{[[:space:]]*corezoid_auth_hash,[[:space:]]*<<\"\)\(.*\)">>[[:space:]]*\},/\2/p' /ebsmnt/conf/capi.config)
AUTH_HASH="ohy8ooj5sabathe4Iquoogu9phoh1soo"

get_hash(){
	login=${1}
	password=${2}

	HASH="$(echo -n "${login}${AUTH_HASH}${password}" | sha1sum | awk '{ print $1 }')"
}

check_user(){
	db_user=$(psql ${PGARGS} conveyor -Atc "select id from logins where login = '${user_login}'")
	if [ -z "${db_user}" ];
	then
		echo "User ${user_login} not found."
		exit 1
	fi
}

update_hash(){
	result=$(psql ${PGARGS} conveyor -Atc "UPDATE logins SET hash1 = '${HASH}' WHERE login = '${user_login}'")
}

check_user ${user_login}

echo "ATTENTION! You will change password for user ${MANUAL_INPUT_1}"
read -p "Enter password: " MANUAL_INPUT_2
user_password=${MANUAL_INPUT_2}

[ $(echo "${MANUAL_INPUT_2}" | awk '{ print length($0)}') -gt 5 ] || { echo "Your new password is too short. Please, try again and enter more than 6 symbols."; exit 1; }

get_hash "${user_login}" "${user_password}"

update_hash || exit 1

echo "OK"
