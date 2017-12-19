#!/bin/bash

cd ~/;

dwlDir="/dwl";

. ${dwlDir}/envvar.sh
. ${dwlDir}/user.sh

for dns in ${@}; do
    sudo rm -rdf /etc/letsencrypt/live/${dns};
    sudo rm -rdf /etc/letsencrypt/archive/${dns};
    sudo rm -rdf /etc/letsencrypt/renewal/${dns}.conf;
done;

. ${dwlDir}/certbot.sh
echo ">> Certbot renewed";

