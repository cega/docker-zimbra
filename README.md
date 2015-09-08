# Zimbra image

## Build:

    docker build -t zimbra .

##  Run

    ZIMBRA_TMP_VOL=$(pwd)/tmp_data
    ZIMBRA_VOL=$(pwd)/opt_zimbra
    docker run \
     -p 25:25 -p 80:80 -p 456:456 -p 587:587 -p 110:110 \
     -p 143:143 -p 993:993 -p 995:995 -p 443:443 \
     -p 8080:8080 -p 8443:8443 -p 7071:7071 -p 9071:9071 \
     -h zimbra86.local \
     -v $ZIMBRA_VOL:/opt/zimbra \
     -v $ZIMBRA_TMP_VOL:/tmp_data \
     -it \
     -e PASSWORD=Zimbra2015 \
     zimbra

##  Environment vars

| ENVAR | default | description |
| ----- | ------- | ------------ |
| PASSWORD | - | admin password |
| ZIMBRA_VER | 8.6.0_GA | zimbra version |
| ZIMBRA_TGZ | zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116 |

## Zimbra versions

| verzija| tgz |
| ------ | ----|
| 8.0.9_GA | zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539 |
| 8.6.0_GA | zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116 |


## Run

### Install zimbra 8.0.9 auto (manual = no), pobrisi raniju instalaciju zimbre ako je bilo (cleanup=yes):

    ZIMBRA_HOST=zimbra ZIMBRA_DOMAIN=out.ba.local \
    ZIMBRA_CLEANUP=no ZIMBRA_MANUAL_SETUP=no \
    ZIMBRA_PASSWORD=password \
    ZIMBRA_VER=8.0 ZIMBRA_UPGRADE=no \
    scripts/run_container.sh /bin/bash

In container shell prompt:

    # ZIMBRA_CLEANUP=yes /start.sh


### Run new container (already installed and configured on host /data/zimbra/ )

    scripts/run_container.sh


Upgrade 8.0 -> 8.6

    ZIMBRA_HOST=zimbra ZIMBRA_DOMAIN=out.ba.local \
    ZIMBRA_CLEANUP=no ZIMBRA_MANUAL_SETUP=yes \
    ZIMBRA_VER=8.6 \
    ZIMBRA_UPGRADE=8.0 \
    scripts/run_container.sh /bin/bash
    
    # su zimbra -c  "/opt/zimbra/bin/zmcontrol start"
    # /start.sh
