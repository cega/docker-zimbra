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
     -v $ZIMBRA_TMP_VOL:/tmp_vol \
     -it \
     -e PASSWORD=Zimbra2015 \
     zimbra

##  Environment vars

| ENVAR | default | description |
| ----- | ------- | ------------ |
| PASSWORD | - | admin password |
| ZIMBRA_VER | 8.6.0_GA | zimbra version |
| ZIMBRA_TGZ | zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116.tgz |


