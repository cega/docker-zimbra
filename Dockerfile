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

VOLUME ["/tmp_data"]
VOLUME ["/opt/zimbra"]

EXPOSE 22
EXPOSE 25
EXPOSE 456
EXPOSE 587
EXPOSE 110
EXPOSE 143
EXPOSE 993
EXPOSE 995
EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 8443
EXPOSE 7071

RUN useradd --uid 999 --home /opt/zimbra zimbra
RUN chown zimbra.zimbra /opt/zimbra
ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh; /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
