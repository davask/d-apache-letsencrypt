if  [ "`find /etc -type d -name "lestencrypt" | wc -l`" = "0" ] || \
    [ "`find /etc/lestencrypt -type d -name "live" | wc -l`" = "0" ] || \
    [ "`find /etc/lestencrypt/live -type d -name "${DWL_USER_DNS}" | wc -l`" = "0" ] || \
    [ "`find /etc/lestencrypt/live/${DWL_USER_DNS} -type f | wc -l`" = "0" ]; then
    echo "> configure certbot AKA let's encrypt";
    if [ ${DWL_CERTBOT_DEBUG} ]; then
        certbot-auto \
            --test-cert \
            --no-self-upgrade \
            --non-interactive --agree-tos \
            --email ${DWL_CERTBOT_EMAIL} \
             --apache \
             --webroot-path /var/www/html \
             --domains "${DWL_USER_DNS}";
    else
        certbot-auto \
            --non-interactive --agree-tos \
            --email ${DWL_CERTBOT_EMAIL} \
             --apache \
             --webroot-path /var/www/html \
             --domains "${DWL_USER_DNS}";
    fi

    echo "> add certbot renewal as a cron task";
    crontab -l > /tmp/dwl/cron;
    echo '0 0 1 */3 * /usr/local/bin/certbot-auto renew --quiet --no-self-upgrade >> /var/log/letsencrypt/le-renew.log' >> /tmp/dwl/cron
    crontab /tmp/dwl/cron;

    service apache2 reload;

else
    echo "> trigger certbot renewal";
    certbot-auto renew
fi
