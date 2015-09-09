#!/bin/bash

export ZIMBRA_VER=${ZIMBRA_VER:-8.0}
export ZIMBRA_HOST=${ZIMBRA_HOST:-zimbra}
export ZIMBRA_DOMAIN=${ZIMBRA_DOMAIN:-out.ba.local}
export CONTAINER_NAME=${CONTAINER_NAME:-zimbra-$ZIMBRA_HOST.$ZIMBRA_DOMAIN-1}
export ZIMBRA_IMAGE=${ZIMBRA_IMAGE:-zimbra-instance-$ZIMBRA_HOST.$ZIMBRA_DOMAIN:$ZIMBRA_VER}
export ZIMBRA_SETUP=no
export ZIMBRA_UPGRADE=no
export ZIMBRA_CLEANUP=no


ZIMBRA_TMP_VOL=/data/zimbra/tmp_data

vol_prefix=/data/zimbra/$ZIMBRA_HOST.$ZIMBRA_DOMAIN
ZIMBRA_VOL_DATA=$vol_prefix/opt_zimbra_data
ZIMBRA_VOL_LOG=$vol_prefix/opt_zimbra_log
ZIMBRA_VOL_CONF=$vol_prefix/opt_zimbra_conf
ZIMBRA_VOL_DB=$vol_prefix/opt_zimbra_db
ZIMBRA_VOL_STORE=$vol_prefix/opt_zimbra_store

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


docker rm -f $CONTAINER_NAME
docker run \
 --name $CONTAINER_NAME \
 $ports \
 -h $ZIMBRA_HOST.$ZIMBRA_DOMAIN \
 -v $ZIMBRA_TMP_VOL:/tmp_data \
 -v $ZIMBRA_VOL_DATA:/opt/zimbra/data \
 -v $ZIMBRA_VOL_LOG:/opt/zimbra/log \
 -v $ZIMBRA_VOL_CONF:/opt/zimbra/conf \
 -v $ZIMBRA_VOL_DB:/opt/zimbra/db \
 -v $ZIMBRA_VOL_STORE:/opt/zimbra/store \
 -v /tmp/syslogdev/log:/dev/log \
 --dns 127.0.0.1 \
 -it \
 -e ZIMBRA_HOST=$ZIMBRA_HOST \
 -e ZIMBRA_DOMAIN=$ZIMBRA_DOMAIN \
 -e ZIMBRA_CLEANUP=$ZIMBRA_CLEANUP \
 -e ZIMBRA_UPGRADE=$ZIMBRA_UPGRADE \
 -e ZIMBRA_SETUP=$ZIMBRA_SETUP \
 $ZIMBRA_IMAGE /bin/bash -c "/start.sh ; service bind9 start ; /opt/zimbra_start.sh ; service bind9 stop ; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf"
