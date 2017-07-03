#! /bin/bash

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    DWL_USER_DNS_CONF=${conf};

    DWL_USER_DNS_DATA=`echo ${DWL_USER_DNS_CONF} | awk -F '[/]' '{print $5}' | sed "s|\.conf||g"`;

    DWL_USER_DNS=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $2}'`;
    DWL_USER_DNS_PORT=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $3}'`;
    DWL_USER_DNS_PORT_CONTAINER=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $1}'`;
    DWL_USER_DNS_SERVERNAME=`echo "${DWL_USER_DNS}" | awk -F '[\.]' '{print $(NF-1)"."$NF}'`;

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

