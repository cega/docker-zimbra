#!/bin/bash

#CONTAINERIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
ZIMBRA_IP=${ZIMBRA_IP:-127.0.0.1}
ZIMBRA_SETUP=${ZIMBRA_SETUP:-auto}

ZIMBRA_CLEANUP=${ZIMBRA_CLEANUP:-no}

DNS_FORWARD_1=${DNS_FORWARD_1:-8.8.8.8}
DNS_FORWARD_2=${DNS_FORWARD_2:-8.8.4.4}

if [[ $ZIMBRA_VER =~ 8\.0 ]] ; then
    ZIMBRA_VER=8.0.9_GA
    ZIMBRA_TGZ=zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539
fi

if [[ $ZIMBRA_VER =~ 8\.6 ]] ; then
    ZIMBRA_VER=8.6.0_GA
    ZIMBRA_TGZ=zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116
    ZIMBRA_PATCH=1182
    ZIMBRA_PATCH_FILE=zcs-patch-${ZIMBRA_VER}_${ZIMBRA_PATCH}
fi


set_zimbra_password() {

su zimbra -c "/opt/zimbra/bin/zmldappasswd $ZIMBRA_PASSWORD"
for flag in r l n p a b
do   
  su zimbra -c "/opt/zimbra/bin/zmldappasswd -$flag $ZIMBRA_PASSWORD"
done

}


get_untar_zimbra_tgz() {

echo get $ZIMBRA_TGZ, then untar it to /tmp_data/

if [ ! -s  /tmp_data/$ZIMBRA_TGZ.tgz ] ; then
   echo $ZIMBRA_TGZ.tgz zero size, erasing
   rm /tmp_data/$ZIMBRA_TGZ.tgz
fi

if [ ! -f /tmp_data/$ZIMBRA_TGZ.tgz ] ; then
 echo "Downloading Zimbra Collaboration $ZIMBRA_VER"
 wget https://files.zimbra.com/downloads/$ZIMBRA_VER/$ZIMBRA_TGZ.tgz -O /tmp_data/$ZIMBRA_TGZ.tgz
fi

cd /tmp_data
tar xzf $ZIMBRA_TGZ.tgz

}

get_untar_zimbra_patch() {

# https://files.zimbra.com/downloads/8.6.0_GA/zcs-patch-8.6.0_GA_1182.tgz


echo get $ZIMBRA_PATCH_FILE, then untar it to /tmp_data/

if [ ! -s  /tmp_data/$ZIMBRA_PATCH_FILE.tgz ] ; then
   echo $ZIMBRA_TGZ.tgz zero size, erasing
   rm /tmp_data/$ZIMBRA_PATCH_FILE.tgz
fi

if [ ! -f /tmp_data/$ZIMBRA_PATCH_FILE.tgz ] ; then
 echo "Downloading Zimbra patch $ZIMBRA_VER / $ZIMBRA_PATCH : $ZIMBRA_PATCH_FILE.tgz"
 wget https://files.zimbra.com/downloads/$ZIMBRA_VER/$ZIMBRA_PATCH_FILE.tgz -O /tmp_data/$ZIMBRA_PATCH_FILE.tgz
fi

cd /tmp_data
tar xzf $ZIMBRA_PATCH_FILE.tgz

}

