#!/bin/bash


ZIMBRA_VER=${ZIMBRA_VER:-8.0}
ZIMBRA_IMAGE=${ZIMBRA_IMAGE:-zimbra-instance:$ZIMBRA_VER}
CONTAINER_NAME=${CONTAINER_NAME:-zimbra-1}
ZIMBRA_TMP_VOL=/data/zimbra/tmp_data

ZIMBRA_HOST=${ZIMBRA_HOST:-zimbra-82}
ZIMBRA_DOMAIN=${ZIMBRA_DOMAIN:-bring.out.ba}

ZIMBRA_TMP_VOL=/data/zimbra/tmp_data

vol_prefix=/data/zimbra/$ZIMBRA_HOST.$ZIMBRA_DOMAIN
ZIMBRA_VOL_DATA=$vol_prefix/opt_zimbra_data
ZIMBRA_VOL_LOG=$vol_prefix/opt_zimbra_log
ZIMBRA_VOL_CONF=$vol_prefix/opt_zimbra_conf
ZIMBRA_VOL_DB=$vol_prefix/opt_zimbra_db
ZIMBRA_VOL_STORE=$vol_prefix/opt_zimbra_store

ZIMBRA_PASSWORD=${ZIMBRA_PASSWORD:-password}

ZIMBRA_IP=${ZIMBRA_IP:-127.0.0.1}
ZIMBRA_DNS_IP=${ZIMBRA_DNS_IP:-127.0.0.1}

DNS_FORWARD_1=192.168.168.20
DNS_FORWARD_2=192.168.168.106

ZIMBRA_CLEANUP=${ZIMBRA_CLEANUP:-no}
ZIMBRA_UPGRADE=${ZIMBRA_UPGRADE:-no}
ZIMBRA_SETUP=${ZIMBRA_SETUP:-no}

docker rm -f $CONTAINER_NAME

ZIMBRA_PRODUCTION=${ZIMBRA_PRODUCTION:-no}

if [[ $ZIMBRA_PRODUCTION == yes ]] ; then
 
ports="
 -p 25:25 -p 80:80 -p 456:456 -p 587:587 -p 110:110 
 -p 143:143 -p 993:993 -p 995:995 -p 443:443 
 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 
"

else

ports="-P"

fi

host_dns=" -h $ZIMBRA_HOST.$ZIMBRA_DOMAIN"
host_dns="$host  --dns $ZIMBRA_DNS_IP"


docker run \
 --name $CONTAINER_NAME \
 $host_dns \
 $ports \
 -h $ZIMBRA_HOST.$ZIMBRA_DOMAIN \
 -v $ZIMBRA_TMP_VOL:/tmp_data \
 -v $ZIMBRA_VOL_DATA:/opt/zimbra/data \
 -v $ZIMBRA_VOL_LOG:/opt/zimbra/log \
 -v $ZIMBRA_VOL_CONF:/opt/zimbra/conf \
 -v $ZIMBRA_VOL_DB:/opt/zimbra/db \
 -v $ZIMBRA_VOL_STORE:/opt/zimbra/store \
 -v /tmp/syslogdev/log:/dev/log \
 -it \
 -e ZIMBRA_PASSWORD=$ZIMBRA_PASSWORD \
 -e ZIMBRA_HOST=$ZIMBRA_HOST \
 -e ZIMBRA_DOMAIN=$ZIMBRA_DOMAIN \
 -e ZIMBRA_CLEANUP=$ZIMBRA_CLEANUP \
 -e ZIMBRA_UPGRADE=$ZIMBRA_UPGRADE \
 -e ZIMBRA_SETUP=$ZIMBRA_SETUP \
 -e DNS_FORWARD_1=$DNS_FORWARD_1 \
 -e DNS_FORWARD_2=$DNS_FORWARD_2 \
 -e ZIMBRA_VER=$ZIMBRA_VER \
 -e ZIMBRA_TGZ=$ZIMBRA_TGZ \
 $ZIMBRA_IMAGE $1 $2 
