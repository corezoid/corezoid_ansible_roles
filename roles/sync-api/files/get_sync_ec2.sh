#!/bin/bash


UPSTREAM_FILE_NEW="/etc/nginx/conf.d/upstream.conf_new"
UPSTREAM_FILE_OLD="/etc/nginx/conf.d/upstream.conf"
MD5_UPSTREAM_OLD=$(md5sum ${UPSTREAM_FILE_OLD} | awk '{print $1}')

if [ ! -f ${UPSTREAM_FILE_NEW} ];
then
	touch ${UPSTREAM_FILE_NEW}
fi

echo "upstream api-sync {" > ${UPSTREAM_FILE_NEW}
ASG_NAME="Corezoid-SyncApi-14W6VOAU6LA0L-rSyncAppAutoScalingGroup-1MZD3Z8JN1COF"

for INSTANCE_ID in $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${ASG_NAME} --query AutoScalingGroups[*].Instances[*].InstanceId --output text);
do

	ASG_INSTANSE=$(aws autoscaling describe-auto-scaling-instances --instance-ids ${INSTANCE_ID})

	TARGET_STATUS=$(echo ${ASG_INSTANSE} | jq .AutoScalingInstances[0].HealthStatus | sed 's/"//g')

	if [ "x${TARGET_STATUS}" == "xHEALTHY" ];
	then
		TARGET_IDS=$(echo ${ASG_INSTANSE} | jq .AutoScalingInstances[0].InstanceId | sed 's/"//g')
		IP=$(aws ec2 describe-instances --instance-ids ${TARGET_IDS}  --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text;)
		echo "server "${IP}":9080;" >> ${UPSTREAM_FILE_NEW}
	fi

done

echo "}" >> ${UPSTREAM_FILE_NEW}

MD5_UPSTREAM_NEW=$(md5sum ${UPSTREAM_FILE_NEW} | awk '{print $1}')

if [ "x${MD5_UPSTREAM_OLD}" == "x${MD5_UPSTREAM_NEW}" ];
then
	echo "Files are equal"
else
	echo "Files aren't equal"
	cp -r ${UPSTREAM_FILE_NEW} ${UPSTREAM_FILE_OLD} && nginx -s reload
	echo "Reload Nginx"
fi
