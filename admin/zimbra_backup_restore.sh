#!/bin/bash


if [[ $RESTORE_MOD == yes_i_want_restore ]] 
then
 cd /tmp_data/backup
 /admin/restore_ldap.sh
 /admin/restore_mysql.sh
 cd /opt/zimbra
 tar xvf /tmp/data/backup/store.tar.gz
 #chown -R zimbra:zimbra /opt/zimbra/store
 /opt/zimbra/libexec/zmfixperms -extended  -verbose
else
  echo "RESTORE_MOD envar not set !"
fi

