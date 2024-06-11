#!/bin/bash

read -p "Enter Your main domain: "  mydomain


if [[ -z "${mydomain}" ]]; then
  mydomain=`wget -S -q -O - http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null`
fi

echo "Mydomain is -  $mydomain!"

#fix ip in vmargs
sed -i -e 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/127.0.0.1/g' /ebsmnt/erlang/*/releases/*/vm.args
cd  /ebsmnt/conf/

#fix hostname in configs

sed -i -e 's|.*{url.*|{url, "https://'"$mydomain"'/api/2/json"},%% url capi when http client send requests|g' conveyor_api_multipart.config
sed -i -e 's|.*{main_page.*|{main_page, "https://'"$mydomain"'"},              %% NB! this parametr MUST BE equal to the 'main_page'   in capi.config|g' conveyor_api_multipart.config
sed -i -e 's|.*corezoid domain.*|{host, <<"'"$mydomain"'">>} %% corezoid domain|g' conveyor_api_multipart.config

sed -i -e 's|.*{domain.*|{domain, <<"https://syncapi.'"$mydomain"'">> }, %% Application url|g' corezoid_api_sync.config
sed -i -e 's|.*{corezoid_host.*|{corezoid_host, <<"https://'"$mydomain"'">>},|g' corezoid_api_sync.config

sed -i -e 's|.*{main_page.*|{main_page, "https://'"$mydomain"'"},|g' capi.config
sed -i -e 's|.*{main_domain.*|{main_domain, "'"$mydomain"'"},|g' capi.config
sed -i -e 's|.*{api_host.*|{api_host, "https://'"$mydomain"'/api"},|g' capi.config
sed -i -e 's|.*{admin_url1.*|{admin_url1, "https://'"$mydomain"'"},|g' capi.config
sed -i -e 's|.*{admin_url2.*|{admin_url2, "https://'"$mydomain"'"},|g' capi.config
sed -i -e 's|.*{site, <<.*|{site, <<"'"$mydomain"'">>},|g' capi.config
sed -i -e 's|.*websocket.*|{ws, <<"'"$mydomain"'">>},  %% websocket|g' capi.config
sed -i -e 's|.*corezoid domain.*|{webhook, <<"'"$mydomain"'">>} %% corezoid domain|g' capi.config
sed -i -e 's|.*{title.*|{title, <<"'"$mydomain"'">>},|g' capi.config

sed -i -e 's|.*{public_callback_prefix.*|{public_callback_prefix, <<"'"$mydomain"'">>},|g' worker.config
sed -i -e 's|.*{title.*|{title, <<"'"$mydomain"'">>}|g' worker.config
sed -i -e 's|.*{title.*|{title, <<"'"$mydomain"'">>}|g' worker.config

sed -i -e 's|.*corezoid api host.*|{host, <<"'"$mydomain"'">>} %% corezoid api host|g' conf_agent_server.config

#finx nginx
cd /etc/nginx/conf.d/
sed -i -e 's|.*server_name.*|    server_name superadmin.'"$mydomain"';|g' superadmin.conf
sed -i -e 's|.*server_name.*|    server_name '"$mydomain"';|g' 01-corezoid.com.conf
sed -i -e 's|.*server_name.*|    server_name syncapi.'"$mydomain"';|g' syncapi-corezoid.conf



for i in `ps ax | grep -E "^capi" | awk '{print $1}'`; do kill $i; done
for i in `ps ax | grep -E "/worker@" | awk '{print $1}'`; do kill $i; done
for i in `ps ax | grep -E "/capi_multipart@" | awk '{print $1}'`; do kill $i; done
for i in `ps ax | grep -E "/conf_agent@" | awk '{print $1}'`; do kill $i; done
for i in `ps ax | grep -E "/corezoid_api_sync@" | awk '{print $1}'`; do kill $i; done


rm -rf /var/run/worker/*
rm -rf /var/run/capi/*
rm -rf /var/run/conveyor_api_multipart/*
rm -rf /var/run/conf_agent_server/*
rm -rf /var/run/corezoid_api_sync/*

mkdir -p /ebsmnt/erlang/*/log
chown -R app-user:app-user /ebsmnt/erlang/*/log/

systemctl restart conf_agent_server
systemctl restart capi
systemctl restart conveyor_api_multipart
systemctl restart corezoid_api_sync

nginx -t
nginx -s reload
sleep 4
echo "for start -> https://$mydomain"
