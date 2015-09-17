#!/bin/bash

	if [[ "$1" == "build" ]] ; then
	   DOCKER_BUILD=yes
	else
	   DOCKER_BUILD=no
fi

. /admin/zimbra_common.sh

. /admin/zimbra_keystrokes.sh

. /admin/zimbra_install_script.sh


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

 
if [[ "$ZIMBRA_SETUP" != "setup" ]] ; then
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

get_untar_zimbra_tgz

#echo checkRequired u install.sh skripti provjerava /etc/hosts koji u docker build fazi ne moze biti ok
#sed -e 's/checkRequired$/echo no requirement/' /tmp_data/$ZIMBRA_TGZ/install.sh  -i
#chown zimbra:zimbra -R /opt/zimbra

# for f in apache core dnscache ldap logger memcached proxy snmp spell store 
# do
#   sudo apt-get purge -y zimbra-$f
# done

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

if [[ $ZIMBRA_SETUP =~ (auto|setup) ]]  ; then
su zimbra -c "/opt/zimbra/bin/zmprov setPassword admin@$ZIMBRA_HOST.$ZIMBRA_DOMAIN $ZIMBRA_PASSWORD"
  zimbra_tar_db_conf_data_ldap_backup

fi


}

init_config
install_supervisor_base

# we need dns for wget ...
service bind9 restart
sleep 10
install_zimbra

install_zimbra_start

if [ -f /zimbra_config.sh ] ;
   source /zimbra_config.sh
fi
