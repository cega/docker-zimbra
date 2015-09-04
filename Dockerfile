#################################################################
# Dockerfile to build Zimbra Collaboration 8.6 container images
# Based on Ubuntu 14.04
# Created by Jorge de la Cruz
#################################################################
FROM ubuntu:14.04
MAINTAINER hernad@bring.out.ba

# Thank you: Jorge de la Cruz <jorgedlcruz@gmail.com>

RUN sed -e 's/archive./ba.archive./' /etc/apt/sources.list -i
RUN sudo apt-get update && sudo apt-get install -y supervisor curl wget

VOLUME ["/tmp_data", "/opt/zimbra", "/opt/zimbra/data", "/opt/zimbra/log", "/opt/zimbra/conf", "/opt/zimbra/conf", "/opt/zimbra/store" ]

EXPOSE 25 456 587 110 143 993 995
EXPOSE 80 443 8080 8443 7071

RUN useradd --shell /bin/bash --uid 999 --home /opt/zimbra zimbra
RUN chown zimbra.zimbra /opt/zimbra
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
