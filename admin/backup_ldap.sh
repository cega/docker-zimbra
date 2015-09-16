#!/bin/bash

PATH=$PATH:/opt/zimbra/bin

if [[ "$1" != "" ]]; then
   BACKUP_DIR=$1
else
   BACKUP_BASE=/tmp_data/backup
   mkdir -p $BACKUP_BASE/ldap
   cd $BACKUP_BASE

   BACKUP_DIR=$BACKUP_BASE/ldap
fi

echo LDAP backup to $BACKUP_DIR
/opt/zimbra/bin/ldap start

/opt/zimbra/libexec/zmslapcat -c $BACKUP_DIR
/opt/zimbra/libexec/zmslapcat $BACKUP_DIR

