#!/bin/bash

if [[ $ZIMBRA_VER =~ 8\.0 ]] ; then
    ZIMBRA_VER=8.0.9_GA
    ZIMBRA_TGZ=zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539
fi

if [[ $ZIMBRA_VER =~ 8\.6 ]] ; then
    ZIMBRA_VER=8.6.0_GA
    ZIMBRA_TGZ=zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116
fi

[ -z  $ZIMBRA_PASSWORD ] && echo ZIMBRA_PASSWORD envar empty && exit 1
 
set_zimbra_password() {

su zimbra -c "/opt/zimbra/bin/zmldappasswd $ZIMBRA_PASSWORD"
for flag in r l n p a b
do   
  su zimbra -c "/opt/zimbra/bin/zmldappasswd -$flag $ZIMBRA_PASSWORD"
done

}

set_zimbra_password

cd /tmp_data/$ZIMBRA_TGZ
./install.sh

su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
