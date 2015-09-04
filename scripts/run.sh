#!/bin/bash

CONTAINER_NAME=zimbra-1
ZIMBRA_TMP_VOL=/data/zimbra/tmp_data
ZIMBRA_VOL=/data/zimbra/opt_zimbra
docker run \
 --name $CONTAINER_NAME \
 -p 25:25 -p 80:80 -p 456:456 -p 587:587 -p 110:110 \
 -p 143:143 -p 993:993 -p 995:995 -p 443:443 \
 -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 \
 -h zimbra86.local \
 -v $ZIMBRA_VOL:/opt/zimbra \
 -v $ZIMBRA_TMP_VOL:/tmp_data \
 -it \
 -e PASSWORD=Zimbra2015 \
 zimbra $1
