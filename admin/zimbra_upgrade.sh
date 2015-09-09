#!/bin/bash

[ -z  $ZIMBRA_PASSWORD ] && echo ZIMBRA_PASSWORD envar empty && exit 1
 
set_zimbra_password() {

su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
su zimbra -c "/opt/zimbra/bin/zmldappasswd $ZIMBRA_PASSWORD"
for flag in r l n p a b
do   
  su zimbra -c "/opt/zimbra/bin/zmldappasswd -$flag $ZIMBRA_PASSWORD"
done

}

set_zimbra_password

cd /tmp_data/$ZIMBRA_TGZ
./install.sh
