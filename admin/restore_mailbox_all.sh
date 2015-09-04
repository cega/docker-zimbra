#!/bin/bash
ZHOME=/tmp_data

ZBACKUP=$ZHOME/mailbox
ZCONFD=$ZHOME/conf
DATE=`date +"%a"`
ZDUMPDIR=$ZBACKUP
#/$DATE

echo $ZDUMPDIR

ZMBOX=/opt/zimbra/bin/zmmailbox
if [ ! -d $ZDUMPDIR ]; then
echo "Backup dir is $ZDUMPDIR - it doesn't exist !"
exit 255;
fi

for mbox in bjasko@bring.out.ba hbakir@bring.out.ba
do
echo " Restoring files from backup $mbox ..."
$ZMBOX -z -m $mbox postRestURL "//?fmt=zip&resolve=reset" $ZDUMPDIR/$mbox.zip
done

