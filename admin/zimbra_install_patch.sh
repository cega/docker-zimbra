#!/bin/bash

. /admin/zimbra_common.sh

#[ -z  $ZIMBRA_PASSWORD ] && echo ZIMBRA_PASSWORD envar empty && exit 1
#set_zimbra_password

get_untar_zimbra_patch

su zimbra -c "/opt/zimbra/bin/zmmailboxdctl stop"

cd /tmp_data/$ZIMBRA_PATCH_FILE
./installPatch.sh

su zimbra -c "/opt/zimbra/bin/zmcontrol restart"
