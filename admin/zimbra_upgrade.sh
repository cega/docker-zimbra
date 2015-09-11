#!/bin/bash

. /admin/zimbra_common.sh

[ -z  $ZIMBRA_PASSWORD ] && echo ZIMBRA_PASSWORD envar empty && exit 1
 
set_zimbra_password

get_untar_zimbra_tgz

cd /tmp_data/$ZIMBRA_TGZ
./install.sh

su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
