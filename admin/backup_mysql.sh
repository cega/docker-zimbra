#!/bin/bash

su
source ~/bin/zmshutil ; zmsetvars

mysql --batch --skip-column-names -e "show databases" | grep -e mbox -e zimbra > /tmp/mysql.db.list
