#!/bin/bash

chown zimbra:zimbra -R /opt/zimbra/data/ldap/
chown zimbra.zimbra -R /tmp_data/backup

[ -z  $ZIMBRA_PASSWORD ] && echo ZIMBRA_PASSWORD envar empty && exit 1

set_zimbra_password() {

  su zimbra -c "/opt/zimbra/bin/zmldappasswd $ZIMBRA_PASSWORD"
  for flag in r l n p a b
  do
     su zimbra -c "/opt/zimbra/bin/zmldappasswd -$flag $ZIMBRA_PASSWORD"
  done

}

if [[ $RESTORE_MOD == yes_i_want_restore ]] 
then

 cd /tmp_data/backup
 su zimbra  -c "PATH=\$PATH:/opt/zimbra/bin && zmcontrol stop &&
 cd /tmp_data/backup && /admin/restore_ldap.sh &&
 /admin/restore_mysql.sh &&
 cd /opt/zimbra && 
 tar xvf /tmp_data/backup/store.tar.gz"

 /opt/zimbra/libexec/zmfixperms -extended  -verbose
 su zimbra -c "/opt/zimbra/bin/ldap start"
 set_zimbra_password
 su zimbra -c "/opt/zimbra/bin/zmcontrol restart"
 su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
else
  echo "RESTORE_MOD envar not set !"
fi


