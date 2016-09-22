#! /bin/bash

. /tmp/dwl/user.sh
. /tmp/dwl/ssh.sh
echo ">> Ubuntu initialized";

echo ">> Base initialized";

. /tmp/dwl/activateconf.sh
echo ">> dwl conf activated";

if [ "`find /etc/lestencrypt/live/${DWL_USER_DNS} -type f &> /dev/null | wc -l`" = "0" ]; then
    . /tmp/dwl/openssl.sh
    echo ">> Openssl initialized";
fi

. /tmp/dwl/apache2.sh
echo ">> apache2 initialized";

. /tmp/dwl/certbot.sh
echo ">> certbot initialized";

. /tmp/dwl/keeprunning.sh
