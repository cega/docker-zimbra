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

ZIMBRA_IP=${ZIMBRA_IP:-127.0.0.1}
ZIMBRA_ETH_DEV=${ZIMBRA_ETH_DEV:-eth0}
if [[ $ZIMBRA_PRODUCTION == yes ]] ; then
 
ports="
 -p $ZIMBRA_IP:25:25 -p $ZIMBRA_IP:80:80 -p $ZIMBRA_IP:456:456 -p $ZIMBRA_IP:587:587 -p $ZIMBRA_IP:110:110 
 -p $ZIMBRA_IP:143:143 -p $ZIMBRA_IP:993:993 -p $ZIMBRA_IP:995:995 -p $ZIMBRA_IP:443:443 
 -p $ZIMBRA_IP:8080:8080 -p $ZIMBRA_IP:8443:8443 -p $ZIMBRA_IP:7071:7071 -p $ZIMBRA_IP:9071:9071 
"
sudo ip addr show | grep $ZIMBRA_IP || \
  sudo ip addr add $ZIMBRA_IP/24 dev $ZIMBRA_ETH_DEV

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
