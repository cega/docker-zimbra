#!/bin/bash

chown zimbra:zimbra -R /opt/zimbra/data/ldap/

if [[ $RESTORE_MOD == yes_i_want_restore ]] 
then

 cd /tmp_data/backup
 su zimbra  -c "PATH=\$PATH:/opt/zimbra/bin &&
cd /tmp_data/backup && /admin/restore_ldap.sh &&
/admin/restore_mysql.sh &&
cd /opt/zimbra && 
tar xvf /tmp_data/backup/store.tar.gz"
 /opt/zimbra/libexec/zmfixperms -extended  -verbose
else
  echo "RESTORE_MOD envar not set !"
fi


