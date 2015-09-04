#!/bin/bash

#[ $(whoami) -eq zimbra ] || echo morate biti zimbra user

CURDIR=$(pwd)
ldap stop

cd /opt/zimbra/data/ldap

mv hdb OLD.hdb

mkdir hdb; cd hdb;mkdir db logs

echo $CURDIR
cd $CURDIR
echo **Most likely, you will need to edit the ldap.bak file and replace the production server name with the new server name**
#sed ... zimbra-82.bring.out.ba/zimbra.local

/opt/zimbra/openldap/sbin/slapadd -q -b "" -F /opt/zimbra/data/ldap/config -cv -l ldap_data/ldap.bak


