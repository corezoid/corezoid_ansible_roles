#!/bin/bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

yum install rabbitmq-server-3.6.10

echo 'EHNZPLWYSDLNSZWZSGMQ' > /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
chmod 400 /var/lib/rabbitmq/.erlang.cookie

echo '[rabbitmq_management].' > /etc/rabbitmq/enabled_plugins

# dowbload from s3 /etc/rabbitmq/rabbitmq.config
