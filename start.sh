#!/bin/sh
## Preparing all the variables like IP, Hostname, etc, all of them from the container

ZIMBRA_VER=${ZIMBRA_VER:-8.6.0_GA}
ZIMBRA_TGZ=${ZIMBRA_TGZ:-zcs-8.6.0_GA_1153.UBUNTU14_64.20141215151116.tgz}

DNS_FORWARD_1=${DNS_FORWARD_1:-8.8.8.8}
DNS_FORWARD_2=${DNS_FORWARD_2:-8.8.4.4}

init_config() {

[ -f /etc/default/bind9.new ] && return

HOSTNAME=$(hostname -a)
DOMAIN=$(hostname -d)
CONTAINERIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
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
@     IN      A      $CONTAINERIP
@     IN      MX     10     $HOSTNAME.$DOMAIN.
$HOSTNAME     IN      A      $CONTAINERIP
ns1     IN      A      $CONTAINERIP
mail     IN      A      $CONTAINERIP
pop3     IN      A      $CONTAINERIP
imap     IN      A      $CONTAINERIP
imap4     IN      A      $CONTAINERIP
smtp     IN      A      $CONTAINERIP
EOF

}


install_supervisor_base() {

[ -f /etc/supervisor/conf.d/base.conf ] && echo supervisor base exists ... && return

cat > /etc/supervisor/conf.d/base.conf <<EOF
[supervisord]
nodaemon=true

[program:syslog]
command=/usr/sbin/rsyslogd -n

[program:bind9]
command=/usr/sbin/named -c /etc/bind/named.conf -u bind -f

[program:ntpd]
command=/etc/init.d/ntp start
EOF

service supervisor restart
}

install_supervisor_zimbra() {

[ -f /etc/supervisor/conf.d/zimbra.conf ] && echo supervisor zimbra exists ... && return
cat > /etc/supervisor/conf.d/zimbra.conf <<EOF
[supervisord]
nodaemon=true

[program:zimbra]
command=/opt/zimbra_start.sh

EOF

cat > /opt/zimbra_start.sh <<EOF
#!/bin/bash
su zimbra -c "/opt/zimbra/bin/zmcontrol start"
EOF

chmod +x /opt/zimbra_start.sh

service supervisor restart
}




install_zimbra () {

[ -f /opt/zimbra/bin/zmcontrol ] && echo zmcontrol exists ... nothing to do && return

## Building and adding the Scripts keystrokes and the config.defaults

# Don't install zimbra-dnscache
touch /tmp_data/installZimbra-keystrokes
cat <<EOF >/tmp_data/installZimbra-keystrokes
y
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

touch /tmp_data/installZimbraScript
cat <<EOF >/tmp_data/installZimbraScript
AVDOMAIN="$DOMAIN"
AVUSER="admin@$DOMAIN"
CREATEADMIN="admin@$DOMAIN"
CREATEADMINPASS="$PASSWORD"
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
LDAPAMAVISPASS="$PASSWORD"
LDAPPOSTPASS="$PASSWORD"
LDAPROOTPASS="$PASSWORD"
LDAPADMINPASS="$PASSWORD"
LDAPREPPASS="$PASSWORD"
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
ldap_bes_searcher_password="$PASSWORD"
ldap_dit_base_dn_config="cn=zimbra"
ldap_nginx_password="$PASSWORD"
mailboxd_directory="/opt/zimbra/mailboxd"
mailboxd_keystore="/opt/zimbra/mailboxd/etc/keystore"
mailboxd_keystore_password="$PASSWORD"
mailboxd_server="jetty"
mailboxd_truststore="/opt/zimbra/java/jre/lib/security/cacerts"
mailboxd_truststore_password="changeit"
postfix_mail_owner="postfix"
postfix_setgid_group="postdrop"
ssl_default_digest="sha256"
zimbraFeatureBriefcasesEnabled="Enabled"
zimbraFeatureTasksEnabled="Enabled"
zimbraIPMode="ipv4"
zimbraMailProxy="FALSE"
zimbraMtaMyNetworks="127.0.0.0/8 $CONTAINERIP/24 [::1]/128 [fe80::]/64"
zimbraPrefTimeZoneId="America/Los_Angeles"
zimbraReverseProxyLookupTarget="TRUE"
zimbraVersionCheckNotificationEmail="admin@$DOMAIN"
zimbraVersionCheckNotificationEmailFrom="admin@$DOMAIN"
zimbraVersionCheckSendNotifications="TRUE"
zimbraWebProxy="FALSE"
zimbra_ldap_userdn="uid=zimbra,cn=admins,cn=zimbra"
zimbra_require_interprocess_security="1"
INSTALL_PACKAGES="zimbra-core zimbra-ldap zimbra-logger zimbra-mta zimbra-snmp zimbra-store zimbra-apache zimbra-spell zimbra-memcached zimbra-proxy"
EOF


##Install the Zimbra Collaboration ##
echo "Downloading Zimbra Collaboration $ZIMBRA_VER"
[ -f /tmp_data/$ZIMBRA_TGZ ] || wget https://files.zimbra.com/downloads/$ZIMBRA_VER/$ZIMBRA_TGZ -O /tmp_data/$ZIMBRA_TGZ

cd /tmp_data
tar xzvf zcs-*.tgz

chown zimbra:zimbra -R /opt/zimbra

echo "Installing Zimbra Collaboration just the Software"
cd /tmp_data/zcs-* && ./install.sh -s < /tmp_data/installZimbra-keystrokes
echo "Installing Zimbra Collaboration injecting the configuration"
/opt/zimbra/libexec/zmsetup.pl -c /tmp_data/installZimbraScript

}

init_config
install_supervisor_base
install_zimbra
install_supervisor_zimbra

