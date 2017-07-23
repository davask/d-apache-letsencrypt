#!/bin/bash

if [ ! -d "/etc/letsencrypt" ]; then
    sudo mkdir -p /etc/letsencrypt;
fi
if [ ! -d "/etc/letsencrypt/live" ]; then
    sudo mkdir -p /etc/letsencrypt/live;
fi

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    . ${dwlDir}/vhost-env.sh;

    if [ "$DWL_USER_DNS_PORT" == "443" ]; then

        echo "> configure virtualhost-tsl for ${DWL_USER_DNS} with path ${DWL_USER_DNS_CONF}";

        if [ -f "/etc/letsencrypt/live/${DWL_USER_DNS}/cert.pem" ]; then

            echo "Update TSL Certificat public key for top domain";
            sudo sed -i "s|# SSLCertificateFile|SSLCertificateFile /etc/letsencrypt/live/${DWL_USER_DNS}/cert.pem|g" ${DWL_USER_DNS_CONF};

        fi
        if [ -f "/etc/letsencrypt/live/${DWL_USER_DNS}/privkey.pem" ]; then

            echo "Update TSL Certificat private key for top domain";
            sudo sed -i "s|# SSLCertificateKeyFile|SSLCertificateKeyFile /etc/letsencrypt/live/${DWL_USER_DNS}/privkey.pem|g" ${DWL_USER_DNS_CONF};

        fi
        if [ -f "/etc/letsencrypt/live/${DWL_USER_DNS}/chain.pem" ]; then

            echo "Update TSL Certificat Chain file for top domain";
            sudo sed -i "s|# SSLCertificateChainFile|SSLCertificateChainFile /etc/letsencrypt/live/${DWL_USER_DNS}/chain.pem|g" ${DWL_USER_DNS_CONF};

        fi
    fi

done;

