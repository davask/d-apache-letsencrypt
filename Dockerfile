FROM davask/d-apache2:2.4-u14.04
MAINTAINER davask <docker@davaskweblimited.com>
LABEL dwl.server.https="open ssl + certbot"

# declare openssl
ENV APACHE_SSL_DIR /etc/apache2/ssl
ENV DWL_USER_DNS dev.davaskweblimited.com
ENV DWL_CERTBOT_EMAIL docker@davaskweblimited.com
ENV DWL_SSLKEY_C "EU"
ENV DWL_SSLKEY_ST "France"
ENV DWL_SSLKEY_L "Vannes"
ENV DWL_SSLKEY_O "davask web limited - docker container"
ENV DWL_SSLKEY_CN "davaskweblimited.com"

# create apache2 ssl directories
RUN /bin/bash -c 'mkdir -p ${APACHE_SSL_DIR}'
RUN /bin/bash -c 'chmod 700 ${APACHE_SSL_DIR}'

# install certbot
RUN /bin/bash -c 'wget https://dl.eff.org/certbot-auto'
RUN /bin/bash -c 'mv certbot-auto /usr/local/bin'
RUN /bin/bash -c 'chmod a+x /usr/local/bin/certbot-auto'
RUN /bin/bash -c 'certbot-auto --noninteractive --os-packages-only'
RUN /bin/bash -c 'rm -rf /var/lib/apt/lists/*'

RUN /bin/bash -c 'if [ -f /etc/apache2/sites-enabled/default-ssl.conf ]; then \
    a2dissite default-ssl; \
fi;'
RUN /bin/bash -c 'if [ -f /etc/apache2/sites-available/default-ssl.conf ]; then \
    rm /etc/apache2/sites-available/default-ssl.conf; \
fi;'

# Configure apache ssl
COPY ./etc/apache2/mods-available/ssl.conf /etc/apache2/mods-available/ssl.conf
# Configure apache default-ssl.conf
COPY ./etc/apache2/sites-enabled/virtualhost.conf /etc/apache2/sites-enabled/virtualhost.conf
COPY ./tmp/dwl/openssl.sh /tmp/dwl/openssl.sh
COPY ./tmp/dwl/certbot.sh /tmp/dwl/certbot.sh
COPY ./tmp/dwl/init.sh /tmp/dwl/init.sh
