#!/bin/bash


if [[ $RESTORE_MOD == yes_i_want_restore ]] 
then
 cd /tmp_data/backup
 /admin/restore_ldap.sh
 /admin/restore_mysql.sh
else
  echo "RESTORE_MOD envar not set !"
fi

