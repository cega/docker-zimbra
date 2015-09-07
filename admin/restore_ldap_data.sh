#!/bin/bash

#[ $(whoami) -eq zimbra ] || echo morate biti zimbra user

CURDIR=$(pwd)
ldap stop


BACKUP_DIR=./ldap_data

LDAP_DIR=/opt/zimbra/data/ldap
mv $LDAP_DIR/mdb $LDAP_DIR/mdb.old

mkdir -p mdb/db

rm -rf /opt/zimbra/data/ldap/config
rm -rf /opt/zimbra/data/ldap/mdb
mkdir -p /opt/zimbra/data/ldap/config  /opt/zimbra/data/ldap/mdb/db /opt/zimbra/data/ldap/accesslog/db


echo $CURDIR
cd $CURDIR
echo **Most likely, you will need to edit the ldap.bak file and replace the production server name with the new server name**
#sed ... zimbra-82.bring.out.ba/zimbra.local

#/opt/zimbra/openldap/sbin/slapadd -q -b "" -F /opt/zimbra/data/ldap/config -cv -l ldap_data/ldap.bak

/opt/zimbra/libexec/zmslapadd -c $BACKUP_DIR/ldap-config.bak

/opt/zimbra/libexec/zmslapadd $BACKUP_DIR/ldap.bak
