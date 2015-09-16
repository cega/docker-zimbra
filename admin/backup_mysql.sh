#!/bin/bash

source ~/bin/zmshutil ; zmsetvars

mysql --batch --skip-column-names -e "show databases" | grep -e mbox -e zimbra > /backup/mysql.db.list

mkdir -p /backup/mysql.sql

for db in `< /backup/mysql.db.list`
do
   /opt/zimbra/mysql/bin/mysqldump $db -S /opt/zimbra/db/mysql.sock -u root \
   --password=ROOT_SQL_PASSWORD > /backup/mysql.sql/$db.sql
   echo -e "Dumped $db\n"
done
