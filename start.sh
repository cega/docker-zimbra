#!/bin/bash

if [[ "$1" == "build" ]] ; then
   DOCKER_BUILD=yes
else
   DOCKER_BUILD=no
fi

#CONTAINERIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
ZIMBRA_IP=${ZIMBRA_IP:-127.0.0.1}
ZIMBRA_SETUP=${ZIMBRA_SETUP:-auto}

ZIMBRA_CLEANUP=${ZIMBRA_CLEANUP:-no}
ZIMBRA_UPGRADE=${ZIMBRA_UPGRADE:-no}	

DNS_FORWARD_1=${DNS_FORWARD_1:-8.8.8.8}
DNS_FORWARD_2=${DNS_FORWARD_2:-8.8.4.4}

if [[ $ZIMBRA_VER =~ 8\.0 ]] ; then
    ZIMBRA_VER=8.0.9_GA
    ZIMBRA_TGZ=zcs-8.0.9_GA_6191.UBUNTU14_64.20141103151539
fi

if [[ $ZIMBRA_VER =~ 8\.6 ]] ; then
    ZIMBRA_VER=8.6.0_GA
    ZIMBRA_TGZ=zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116
fi


zimbra_keystrokes() {

if [[ $ZIMBRA_VER =~ ^8\.6.* ]] && [[ "$ZIMBRA_UPGRADE" == "8.0" ]] ; then

# Don't install zimbra-dnscache
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
n
y
y
y
n
y
EOF

return
fi
  
if [[ $ZIMBRA_VER =~ ^8\.6.* ]] ; then  
# Don't install zimbra-dnscache
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
n
y
y
y
n
y
y
y
y
y
y
y
y
EOF

return
fi



if [[ $ZIMBRA_VER =~ ^8\.0.* ]] ; then  
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
y
y
y
y
y
y
y
y
y
y
y
y
EOF

return
fi


}


zimbra_install_config() {

touch /tmp_data/installZimbraScript

if [[ $ZIMBRA_VER =~ ^8\.6.* ]] ; then 
 
cat <<EOF >/tmp_data/installZimbraScript
AVDOMAIN="$DOMAIN"
AVUSER="admin@$DOMAIN"
CREATEADMIN="admin@$DOMAIN"
CREATEADMINPASS="$ZIMBRA_PASSWORD"
CREATEDOMAIN="$DOMAIN"
DOCREATEADMIN="yes"
DOCREATEDOMAIN="yes"
DOTRAINSA="yes"
EXPANDMENU="no"
HOSTNAME="$HOSTNAME.$DOMAIN"
HTTPPORT="8080"
HTTPPROXY="TRUE"
HTTPPROXYPORT="80"
HTTPSPORT="8443"
HTTPSPROXYPORT="443"
IMAPPORT="7143"
IMAPPROXYPORT="143"
IMAPSSLPORT="7993"
IMAPSSLPROXYPORT="993"
INSTALL_WEBAPPS="service zimlet zimbra zimbraAdmin"
JAVAHOME="/opt/zimbra/java"
LDAPAMAVISPASS="$ZIMBRA_PASSWORD"
LDAPPOSTPASS="$ZIMBRA_PASSWORD"
LDAPROOTPASS="$ZIMBRA_PASSWORD"
LDAPADMINPASS="$ZIMBRA_PASSWORD"
LDAPREPPASS="$ZIMBRA_PASSWORD"
LDAPBESSEARCHSET="set"
LDAPHOST="$HOSTNAME.$DOMAIN"
LDAPPORT="389"
LDAPREPLICATIONTYPE="master"
LDAPSERVERID="2"
MAILBOXDMEMORY="972"
MAILPROXY="TRUE"
MODE="https"
MYSQLMEMORYPERCENT="30"
POPPORT="7110"
POPPROXYPORT="110"
POPSSLPORT="7995"
POPSSLPROXYPORT="995"
PROXYMODE="https"
REMOVE="no"
RUNARCHIVING="no"
RUNAV="yes"
RUNCBPOLICYD="no"
RUNDKIM="yes"
RUNSA="yes"
RUNVMHA="no"
SERVICEWEBAPP="yes"
SMTPDEST="admin@$DOMAIN"
SMTPHOST="$HOSTNAME.$DOMAIN"
SMTPNOTIFY="yes"
SMTPSOURCE="admin@$DOMAIN"
SNMPNOTIFY="yes"
SNMPTRAPHOST="$HOSTNAME.$DOMAIN"
SPELLURL="http://$HOSTNAME.$DOMAIN:7780/aspell.php"
STARTSERVERS="yes"
SYSTEMMEMORY="3.8"
TRAINSAHAM="ham.$RANDOMHAM@$DOMAIN"
TRAINSASPAM="spam.$RANDOMSPAM@$DOMAIN"
UIWEBAPPS="yes"
UPGRADE="yes"
USESPELL="yes"
VERSIONUPDATECHECKS="TRUE"
VIRUSQUARANTINE="virus-quarantine.$RANDOMVIRUS@$DOMAIN"
ZIMBRA_REQ_SECURITY="yes"
ldap_bes_searcher_password="$ZIMBRA_PASSWORD"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$ZIMBRA_PASSWORD"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$ZIMBRA_PASSWORD"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/java/jre/lib/security/cacerts"
mailboxd_truststore_password=changeit
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="FALSE"
zimbraMtaMyNetworks="127.0.0.0/8 $ZIMBRA_IP/24 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId="Europe/Berlin"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckNotificationEmail="admin@$DOMAIN"
zimbraVersionCheckNotificationEmailFrom="admin@$DOMAIN"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="FALSE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy"
EOF

fi

if [[ $ZIMBRA_VER =~ ^8\.0.* ]] ; then  
cat <<EOF >/tmp_data/installZimbraScript
AVDOMAIN=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
AVUSER=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
CREATEADMIN=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
CREATEDOMAIN=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
DOCREATEADMIN=yes
DOCREATEDOMAIN=yes
DOTRAINSA=yes
EXPANDMENU=no
HOSTNAME=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
HTTPPORT=80
HTTPPROXY=FALSE
HTTPPROXYPORT=8080
HTTPSPORT=443
HTTPSPROXYPORT=8443
IMAPPORT=143
IMAPPROXYPORT=7143
IMAPSSLPORT=993
IMAPSSLPROXYPORT=7993
JAVAHOME=/opt/zimbra/java
LDAPBESSEARCHSET=set
LDAPHOST=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
LDAPPORT=389
LDAPREPLICATIONTYPE=master
LDAPSERVERID=2
MAILBOXDMEMORY=1996
MAILPROXY=FALSE
MODE=https
MTAAUTHHOST=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
MYSQLMEMORYPERCENT=30
POPPORT=110
POPPROXYPORT=7110
POPSSLPORT=995
POPSSLPROXYPORT=7995
PROXYMODE=https
REMOVE=no
RUNARCHIVING=no
RUNAV=yes
RUNCBPOLICYD=no
RUNDKIM=yes
RUNSA=yes
RUNVMHA=no
SMTPDEST=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
SMTPHOST=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
SMTPNOTIFY=yes
SMTPSOURCE=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
SNMPNOTIFY=yes
SNMPTRAPHOST=$ZIMBRA_HOST.$ZIMBRA_DOMAIN
SPELLURL=http://$ZIMBRA_HOST.$ZIMBRA_DOMAIN:7780/aspell.php
STARTSERVERS=yes
SYSTEMMEMORY=7.8
TRAINSAHAM=ham.ahvofc1lo@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
TRAINSASPAM=spam.dutib9d3g@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
UPGRADE=yes
USESPELL=yes
VERSIONUPDATECHECKS=TRUE
VIRUSQUARANTINE=virus-quarantine.gwr_p1i_o0@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
ZIMBRA_REQ_SECURITY=yes
ldap_bes_searcher_password=$ZIMBRA_PASSWORD
ldap_dit_base_dn_config=cn=zimbra
ldap_nginx_password=$ZIMBRA_PASSWORD
mailboxd_directory=/opt/zimbra/mailboxd
mailboxd_keystore=/opt/zimbra/mailboxd/etc/keystore
mailboxd_keystore_password=$ZIMBRA_PASSWORD
mailboxd_server=jetty
mailboxd_truststore=/opt/zimbra/java/jre/lib/security/cacerts
mailboxd_truststore_password=changeit
postfix_mail_owner=postfix
postfix_setgid_group=postdrop
ssl_default_digest=sha1
zimbraClusterType=none
zimbraFeatureBriefcasesEnabled=Disabled
zimbraFeatureTasksEnabled=Enabled
zimbraIPMode=ipv4
zimbraMailProxy=FALSE
zimbraMtaMyNetworks="127.0.0.0/8 $ZIMBRA_IP/24 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId=Europe/Berlin
zimbraReverseProxyLookupTarget=TRUE
zimbraVersionCheckNotificationEmail=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
zimbraVersionCheckNotificationEmailFrom=admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN
zimbraVersionCheckSendNotifications=TRUE
zimbraWebProxy=FALSE
zimbra_ldap_userdn=uid=zimbra,cn=admins,cn=zimbra
zimbra_require_interprocess_security=1
INSTALL_PACKAGES="zimbra-apache zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-spell zimbra-store "
EOF

fi

}

init_config() {

found=`cat /etc/bind/named.conf.local | grep -c $ZIMBRA_DOMAIN`

if [[ $found != 0 ]]; then 
  return
fi
#HOSTNAME=$(hostname -a)
#DOMAIN=$(hostname -d)
HOSTNAME=$ZIMBRA_HOST
DOMAIN=$ZIMBRA_DOMAIN
RANDOMHAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMSPAM=$(date +%s|sha256sum|base64|head -c 10)
RANDOMVIRUS=$(date +%s|sha256sum|base64|head -c 10)
## Installing the DNS Server ##

echo "Configuring DNS Server"
sed "s/-u/-4 -u/g" /etc/default/bind9 > /etc/default/bind9.new
cp /etc/default/bind9.new /etc/default/bind9

rm /etc/bind/named.conf.options
cat <<EOF >>/etc/bind/named.conf.options
options {
directory "/var/cache/bind";

listen-on { 127.0.0.1; }; # ns1 private IP address - listen on private network only
allow-transfer { none; }; # disable zone transfers by default

forwarders {
 $DNS_FORWARD_1;
 $DNS_FORWARD_2;
};
auth-nxdomain no; # conform to RFC1035
#listen-on-v6 { any; };

};
EOF

cat <<EOF >/etc/bind/named.conf.local
zone "$DOMAIN" {
	type master;
	file "/etc/bind/db.$DOMAIN";
};
EOF

touch /etc/bind/db.$DOMAIN
cat <<EOF >/etc/bind/db.$DOMAIN
\$TTL  604800
@      IN      SOA    ns1.$DOMAIN. root.localhost. (
			      2        ; Serial
			604800        ; Refresh
			  86400        ; Retry
			2419200        ; Expire
			604800 )      ; Negative Cache TTL
;
@     IN      NS      ns1.$DOMAIN.
@     IN      A      $ZIMBRA_IP
@     IN      MX     10     $HOSTNAME.$DOMAIN.
$HOSTNAME.$DOMAIN.   IN      MX     10   $HOSTNAME.$DOMAIN.
$HOSTNAME     IN      A      $ZIMBRA_IP
ns1      IN      A      $ZIMBRA_IP
mail     IN      A      $ZIMBRA_IP
pop3     IN      A      $ZIMBRA_IP
imap     IN      A      $ZIMBRA_IP
imap4    IN      A      $ZIMBRA_IP
smtp     IN      A      $ZIMBRA_IP
EOF

}


install_supervisor_base() {

[ -f /etc/supervisor/conf.d/base.conf ] && echo supervisor base exists ... && return

cat > /etc/supervisor/conf.d/base.conf <<EOF
[supervisord]
nodaemon=true

[program:bind9]
command=/usr/sbin/named -c /etc/bind/named.conf -u bind -f

EOF

}

install_zimbra_start() {

[ -f /opt/zimbra_start.sh ] && echo zimbra_start.sh exists ... && return

cat > /opt/zimbra_start.sh <<EOF
#!/bin/bash
rm -f /opt/zimbra/openldap/var/run/slapd.pid
su zimbra -c "/opt/zimbra/bin/zmcontrol start"
EOF

chmod +x /opt/zimbra_start.sh

}


install_zimbra () {

if [ "$ZIMBRA_CLEANUP" == "yes" ] ; then
   rm -f -r /opt/zimbra/*
   rm -f -r /opt/zimbra/t*
   chown -R zimbra:zimbra /opt/zimbra
fi

 
if [[ "$ZIMBRA_UPGRADE" == "no" ]] && [[ "$ZIMBRA_SETUP" != "setup" ]] ; then
   [ -f /opt/zimbra/bin/zmcontrol ] && echo zmcontrol exists ... nothing to do && return
fi

## Building and adding the Scripts keystrokes and the config.defaults
cat <<EOF >/dev/null

Agree with License ? [N]

The Zimbra Collaboration Server does not appear to be installed,
yet there appears to be a ZCS directory structure in /opt/zimbra.

Would you like to delete /opt/zimbra before installing? [N] 

Select the packages to install

Install zimbra-ldap [Y] 
Install zimbra-logger [Y] 
Install zimbra-mta [Y] 
Install zimbra-dnscache [Y] n
Install zimbra-snmp [Y] 
Install zimbra-store [Y] 
Install zimbra-apache [Y] 
Install zimbra-spell [Y] 
Install zimbra-memcached [Y] 
Install zimbra-proxy [Y] 
Checking required space for zimbra-core
Checking space for zimbra-store
Checking required packages for zimbra-store
zimbra-store package check complete.
Installing:
    zimbra-core
    zimbra-ldap
    zimbra-logger
    zimbra-mta
    zimbra-snmp
    zimbra-store
    zimbra-apache
    zimbra-spell
    zimbra-memcached
    zimbra-proxy
The system will be modified.  Continue? [N] y
EOF

zimbra_keystrokes
zimbra_install_config

if [[ $ZIMBRA_SETUP =~ (auto|manual) ]] ; then

##Install the Zimbra Collaboration ##

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

echo checkRequired u install.sh skripti provjerava /etc/hosts koji u docker build fazi ne moze biti ok
sed -e 's/checkRequired$/echo no requirement/' /tmp_data/$ZIMBRA_TGZ/install.sh  -i
#chown zimbra:zimbra -R /opt/zimbra

#if [[ "$ZIMBRA_UPGRADE" == "no" ]] ; then
# for f in apache core dnscache ldap logger memcached proxy snmp spell store 
# do
#   sudo apt-get purge -y zimbra-$f
# done
#fi

fi

cd /tmp_data/$ZIMBRA_TGZ

echo zimbra setup: $ZIMBRA_SETUP


if [[ "$ZIMBRA_SETUP" == "manual" ]] ; then
   ./install.sh 
else

   if [[ "$ZIMBRA_SETUP" == "auto" ]] ; then
     ./install.sh -s < /tmp_data/installZimbra-keystrokes
   fi

   if [[ "$DOCKER_BUILD" == "no" ]] &&  [[ $ZIMBRA_SETUP =~ (setup|auto) ]] ; then 
     echo "Installing Zimbra Collaboration injecting the configuration"
     /opt/zimbra/libexec/zmfixperms -extended  -verbose
     # read from config e.g /opt/zimbra/config.31577
     /opt/zimbra/libexec/zmsetup.pl -c /tmp_data/installZimbraScript
   fi
fi

if [[ "$ZIMBRA_UPGRADE" == "no" ]] && [[ "$DOCKER_BUILD" == "no" ]] && [[ $ZIMBRA_SETUP =~ (auto|setup) ]]  ; then
su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
fi


}

init_config
install_supervisor_base

# we need dns for wget ...
service bind9 restart
sleep 10
install_zimbra

install_zimbra_start

