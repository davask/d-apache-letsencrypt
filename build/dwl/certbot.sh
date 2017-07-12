#!/bin/bash

if [ ! -d "/home/admin/.local" ]; then
  echo "create dir /home/admin/.local";
  sudo mkdir -p /home/admin/.local;
  sudo chown admin:root /home/admin/.local
fi

for conf in `sudo find /etc/apache2/sites-available -type f -name "*.conf"`; do

    DWL_USER_DNS_CONF=${conf};

    DWL_USER_DNS_DATA=`echo ${DWL_USER_DNS_CONF} | awk -F '[/]' '{print $5}' | sed "s|\.conf||g"`;

    DWL_USER_DNS=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $2}'`;
    DWL_USER_DNS_PORT=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $3}'`;
    DWL_USER_DNS_PORT_CONTAINER=`echo ${DWL_USER_DNS_DATA} | awk -F '[_]' '{print $1}'`;
    DWL_USER_DNS_SERVERNAME=`echo "${DWL_USER_DNS}" | awk -F '[\.]' '{print $(NF-1)"."$NF}'`;

    if [ "$DWL_USER_DNS_PORT" == "443" ]; then

        echo "[CERTBOT-AUTO] ${DWL_USER_DNS}";

        DWL_CERTBOT_RENEW=false;

        if  [ "`sudo find /etc/lestencrypt/live -type d -name "${DWL_USER_DNS}" | wc -l`" == "0" ] || [ "`sudo find /etc/lestencrypt/live/${DWL_USER_DNS} -type f | wc -l`" == "0" ]; then

            echo "> configure certbot AKA let's encrypt";

            if [ -d "/dwl/etc/letsencrypt/live/${DWL_USER_DNS}" ]; then

                if [ ! -d "/etc/letsencrypt/live" ]; then
                    sudo mkdir -p /etc/letsencrypt/live;
                fi

                if [ -d "/etc/letsencrypt/live/${DWL_USER_DNS}" ]; then
                    sudo rm -rdf /etc/letsencrypt/live/${DWL_USER_DNS};
                fi

                sudo cp -rdf /dwl/etc/letsencrypt/live/${DWL_USER_DNS} /etc/letsencrypt/live;

                DWL_CERTBOT_RENEW=true;

            else

                run_certbot="certbot-auto --non-interactive --agree-tos --email ${DWL_CERTBOT_EMAIL} --apache --domains \"${DWL_USER_DNS}\"";

                if [ "${DWL_CERTBOT_DEBUG}" == "true" ]; then
                    echo ">> configure DEBUG certbot";
                    run_certbot="${run_certbot} --no-self-upgrade --test-cert";
                else
                    run_certbot="${run_certbot} --no-bootstrap";
                    echo ">> configure PROD certbot";
                fi

                if [ "`certbot-auto certificates | grep "No certs found." | wc -l`" == "0" ]; then
                    echo ">> expand certificat";
                    run_certbot="${run_certbot} --expand";
                else
                    echo ">> create certificat";
                fi

                echo "${run_certbot}";
                sh -c "${run_certbot}";

            fi

        else

            DWL_CERTBOT_RENEW=true;

        fi
    fi


done;

if [ "`crontab -l | grep 'certbot' | wc -l`" = "0" ]; then

    echo "> add certbot renewal as a cron task";
    crontab -l | sudo tee /dwl/cron;
    echo '0 0 1 */3 * /usr/local/bin/certbot-auto renew --quiet --no-self-upgrade >> /var/log/letsencrypt/le-renew.log' | sudo tee --append /dwl/cron;
    crontab /dwl/cron;

fi

if [ ${DWL_CERTBOT_RENEW} ]; then
    echo "> trigger certbot renewal";
    # test certbot-auto renew --dry-run;
    sudo certbot-auto renew;
fi
