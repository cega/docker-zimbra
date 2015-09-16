#!/bin/bash

SRC=$1

[[ -z $SRC ]] && echo navedi source server && exit 1 


BACKUP_BASE=/tmp_data/backup

rsync -avz --delete root@$SRC:$BACKUP_BASE/ $BACKUP_BASE/
chown zimbra:zimbra -R $BACKUP_BASE
