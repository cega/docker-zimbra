
source ~/bin/zmshutil ; zmsetvars

for db in `cat mysql.db.list |grep mbox`
do
    mysql -u root --password=$mysql_root_password -e "drop database $db"
    echo -e "Dropped $db"
done

mysql -u root --password=$mysql_root_password -e "drop database zimbra"

rm -rf /opt/zimbra/db/data/ib*


mysql.server restart
for db in `cat mysql.db.list`
do
    mysql -e "create database $db character set utf8"
    echo "Created $db"
done

mysql zimbra < mysql.sql/zimbra.sql
for sql in mysql.sql/mbox*
do
    mysql `basename $sql .sql` < $sql
    echo -e "Updated `basename $sql .sql` \n"
done
