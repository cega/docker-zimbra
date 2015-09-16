# Zimbra image


## Build docker images

build:

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba ZIMBRA_VER=8.0 scripts/build.sh

Output:

    zimbra-instance-zimbra-82.bring.out.ba   8.0                                        c618d8934d80        42 seconds ago      2.668 GB
    zimbra-instance-zimbra.out.ba.local      8.0                                        75323d19eaf8        20 minutes ago      2.668 GB
    zimbra                                   latest                                     36b1ef57de2d        32 minutes ago      307.4 MB
    zimbra-dev                               latest                                     38d36ae5665a        2 hours ago         328.6 MB


## Run zimbra-82.bring.out.ba instance 


Volumes location: /data/zimbra/zimbra-82.bring.out.ba/{opt_zimbra_data, opt_zimbra_db, opt_zimbra_conf, opt_zimbra_store}
    

    ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba ZIMBRA_VER=8.0 scripts/run_instance.sh


## Backup scripts

1) [backup_store](https://raw.githubusercontent.com/hernad/docker-zimbra/master/admin/backup_store.sh)
2) [backup_ldap](https://raw.githubusercontent.com/hernad/docker-zimbra/master/admin/backup_ldap.sh)   
3) [backup_mysql](https://raw.githubusercontent.com/hernad/docker-zimbra/master/admin/backup_mysql.sh) 
  

     Backup lokacija #  ls /tmp_data/backup/

     -> ldap  mysql.db.list  mysql.sql  store.tar.gz


## Restore zimbra data from backup


Backup has to be taken the server with the same name (eg. zimbra-82.bring.out.ba), ZIMBRA_PASSWORD the same as the old server

Backup location: /tmp_data/backup/{ldap/, mysql.db.list, mysql.sql/, store.tar.gz}
Instance is running ...


      docker exec -ti  zimbra-zimbra-82.bring.out.ba-1 /bin/bash



Container shell prompt:

      root@zimbra-82:/# ZIMBRA_PASSWORD=the_same_as_the_old_server RESTORE_MOD=yes_i_want_restore admin/zimbra_backup_restore.sh


## Upgrade zimbra-82.bring.out.ba instance to 8.6


Container shell prompt:

      root@zimbra-82:/# ZIMBRA_PASSWORD=the_same_as_the_old_server ZIMBRA_VER=8.6 admin/zimbra_upgrade.sh


Create new docker image from upgraded container:

      docker commit zimbra-zimbra-82.bring.out.ba-1 zimbra-instance-zimbra-82.bring.out.ba:8.6
 

## Install patch zimbra 8.6 P4


     docker exec -ti  zimbra-zimbra-82.bring.out.ba-1 /bin/bash


Run upgrade:

     root@zimbra-82:/# ZIMBRA_VER=8.6 admin/zimbra_install_patch.sh


Commit patched version as new zimbra-instance image:
 
     docker commit zimbra-zimbra-82.bring.out.ba-1 zimbra-instance-zimbra-82.bring.out.ba:8.6.P4


## Run patched instance


     ZIMBRA_HOST=zimbra-82 ZIMBRA_DOMAIN=bring.out.ba ZIMBRA_IMAGE=zimbra-instance-zimbra-82.bring.out.ba:8.6.P4 scripts/run_instance.sh



## Backup db, conf, data, ldap backup


     ZIMBRA_VER=8.6 admin/tar_ldap.sh P4


    root@zimbra-82:/# ls /tmp_data/zimbra-82.bring.out.ba/8.6.0_GA.P4/

    -> ldap/  opt_zimbra.tar.gz


##  Environment vars

| ENVAR | default | description |
| ----- | ------- | ------------ |
| ZIMBRA_PASSWORD | - | admin password |
| ZIMBRA_VER | 8.6 | zimbra version |

## Zimbra versions

| version | tgz |
| ------ | ----|
| 8.0.9_GA | zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539 |
| 8.6.0_GA | zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116 |


