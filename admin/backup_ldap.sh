#!/bin/bash

PATH=$PATH:/opt/zimbra/bin

mkdir -p /backup/ldap

cd /backup

if [[ "$1" != "" ]]; then
 BACKUP_DIR=$1
else
  BACKUP_DIR=./ldap
fi

echo LDAP backup to $BACKUP_DIR
/opt/zimbra/bin/ldap start

/opt/zimbra/libexec/zmslapcat -c $BACKUP_DIR
/opt/zimbra/libexec/zmslapcat $BACKUP_DIR

