FROM ubuntu:14.04
MAINTAINER hernad@bring.out.ba

# Thank you: Jorge de la Cruz <jorgedlcruz@gmail.com>

RUN sed -e 's/archive./ba.archive./' /etc/apt/sources.list -i
RUN sudo apt-get update && sudo apt-get install -y supervisor ntp curl bind9 bind9utils bind9-doc dnsutils psmisc wget openssh-client vim

RUN echo "Download and install Zimbra Collaboration dependencies"
RUN sudo apt-get install -y netcat-openbsd sudo libidn11 libpcre3 libgmp10 libexpat1 libstdc++6 libperl5.18 libaio1 resolvconf unzip pax sysstat sqlite3


VOLUME ["/tmp_data", "/opt/zimbra", "/opt/zimbra/data", "/opt/zimbra/log", "/opt/zimbra/conf", "/opt/zimbra/conf", "/opt/zimbra/store" ]

EXPOSE 25 456 587 110 143 993 995
EXPOSE 80 443 8080 8443 7071

ADD sudoers /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN useradd --shell /bin/bash --uid 999 --home /opt/zimbra zimbra
RUN chown zimbra.zimbra /opt/zimbra
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh; /opt/zimbra_start.sh ; service rsyslog stop ; service bind9 stop ; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
