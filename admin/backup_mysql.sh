#!/bin/bash

source ~/bin/zmshutil ; zmsetvars

BACKUP_BASE=/tmp_data/backup
mkdir -p $BACKUP_BASE/mysql.sql
cd $BACKUP_BASE

mysql --batch --skip-column-names -e "show databases" | grep -e mbox -e zimbra > $BACKUP_BASE/mysql.db.list

for db in `< $BACKUP_BASE/mysql.db.list`
do
   /opt/zimbra/mysql/bin/mysqldump $db -S /opt/zimbra/db/mysql.sock -u root \
   --password=ROOT_SQL_PASSWORD > $BACKUP_BASE/mysql.sql/$db.sql
   echo -e "Dumped $db\n"
done
