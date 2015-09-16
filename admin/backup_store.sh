#!/bin/bash


echo run as root !

BACKUP_ROOT=/tmp_data/backup
mkdir -p $BACKUP_ROOT

chown zimbra:zimbra -R $BACKUP_ROOT

cd /opt/zimbra

tar -czvf $BACKUP_ROOT/store.tar.gz store

