#!/bin/bash

CONTAINER_NAME=zimbra-1
ZIMBRA_TMP_VOL=/data/zimbra/tmp_data
ZIMBRA_VOL=/data/zimbra/opt_zimbra
ZIMBRA_VOL_DATA=/data/zimbra/opt_zimbra_data
ZIMBRA_VOL_LOG=/data/zimbra/opt_zimbra_log
ZIMBRA_VOL_CONF=/data/zimbra/opt_zimbra_conf
ZIMBRA_VOL_DB=/data/zimbra/opt_zimbra_db
ZIMBRA_VOL_STORE=/data/zimbra/opt_zimbra_store

PASSWORD=Zimbra2015
DNS_FORWARD_1=192.168.168.20
DNS_FORWARD_2=192.168.168.106
ZIMBRA_HOST=zimbra
ZIMBRA_DOMAIN=local

docker run \
 --name $CONTAINER_NAME \
 -p 25:25 -p 80:80 -p 456:456 -p 587:587 -p 110:110 \
 -p 143:143 -p 993:993 -p 995:995 -p 443:443 \
 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 \
 -h $ZIMBRA_HOST.$ZIMBRA_DOMAIN \
 -v $ZIMBRA_TMP_VOL:/tmp_data \
 -v $ZIMBRA_VOL:/opt/zimbra \
 -v $ZIMBRA_VOL_DATA:/opt/zimbra/data \
 -v $ZIMBRA_VOL_LOG:/opt/zimbra/log \
 -v $ZIMBRA_VOL_CONF:/opt/zimbra/conf \
 -v $ZIMBRA_VOL_DB:/opt/zimbra/db \
 -v $ZIMBRA_VOL_STORE:/opt/zimbra/store \
 --dns 127.0.0.1 \
 -it \
 -e ZIMBRA_HOST=$ZIMBRA_HOST \
 -e ZIMBRA_DOMAIN=$ZIMBRA_DOMAIN \
 -e ZIMBRA_CLEANUP=$ZIMBRA_CLEANUP \
 -e PASSWORD=$PASSWORD \
 -e DNS_FORWARD_1=$DNS_FORWARD_1 \
 -e DNS_FORWARD_2=$DNS_FORWARD_2 \
 zimbra $1
