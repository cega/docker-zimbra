#!/bin/bash


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


