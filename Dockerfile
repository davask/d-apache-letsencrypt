FROM davask/d-apache-openssl:2.4-u16.04
MAINTAINER davask <docker@davaskweblimited.com>
LABEL dwl.server.certificat="letsencrypt"

# declare letsencrypt
ENV DWL_CERTBOT_EMAIL docker@davaskweblimited.com
ENV DWL_CERTBOT_DEBUG false

# install certbot
RUN wget https://dl.eff.org/certbot-auto
RUN mv certbot-auto /usr/local/bin
RUN chmod a+x /usr/local/bin/certbot-auto
RUN certbot-auto --noninteractive --os-packages-only

RUN mkdir -p /etc/lestencrypt/live

COPY ./tmp/dwl/certbot.sh /tmp/dwl/certbot.sh
COPY ./tmp/dwl/init.sh /tmp/dwl/init.sh
