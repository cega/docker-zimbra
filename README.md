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


### Build docker images

build:

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba ZIMBRA_VER=8.0 scripts/build.sh

Output:

    zimbra-instance-zimbra-82.bring.out.ba   8.0                                        c618d8934d80        42 seconds ago      2.668 GB
    zimbra-instance-zimbra.out.ba.local      8.0                                        75323d19eaf8        20 minutes ago      2.668 GB
    zimbra                                   latest                                     36b1ef57de2d        32 minutes ago      307.4 MB
    zimbra-dev                               latest                                     38d36ae5665a        2 hours ago         328.6 MB


### Run zimbra-82.bring.out.ba instance 


Volumes location: /data/zimbra/zimbra-82.bring.out.ba/{opt_zimbra_data, opt_zimbra_db, opt_zimbra_conf, opt_zimbra_store}
    

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba ZIMBRA_VER=8.0 scripts/run_instance.sh


### Restore data from backup


Backup has to be taken the same server (eg. zimbra-82.bring.out.ba)

Backup location: /tmp_data/backup/{ldap/, mysql.db.list, mysql.sql/, store.tar.gz}
Instance is running ...


      docker exec -ti  zimbra-zimbra-82.bring.out.ba-1 /bin/bash

Container shell prompt:

      root@zimbra-82:/# RESTORE_MOD=yes_i_want_restore admin/zimbra_backup_restore.sh



