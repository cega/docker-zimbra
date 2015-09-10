#!/bin/bash

PATH=$PATH:/opt/zimbra/bin

if [[ "$1" != "" ]]; then
   BACKUP_DIR=$1
else
  BACKUP_DIR=./ldap
fi

/opt/zimbra/libexec/zmslapcat -c BACKUP_DIR
/opt/zimbra/libexec/zmslapcat BACKUP_DIR

