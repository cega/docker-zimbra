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

Install zimbra 8.0.9 auto (manual = no), pobrisi raniju instalaciju zimbre ako je bilo (cleanup=yes):

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba \
    ZIMBRA_CLEANUP=yes ZIMBRA_MANUAL_INSTALL=no \
    ZIMBRA_PASSWORD=password \
    ZIMBRA_VER=8.0.9_GA ZIMBRA_TGZ=zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539 ZIMBRA_UPGRADE=no \
    scripts/run.sh /bin/bash /start.sh


Upgrade 8.0 -> 8.6

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba \
    ZIMBRA_CLEANUP=no ZIMBRA_MANUAL_INSTALL=no \
    ZIMBRA_VER=8.6.0_GA ZIMBRA_TGZ=zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116 \
    ZIMBRA_UPGRADE=8.0 \
    scripts/run.sh /bin/bash /start.sh



