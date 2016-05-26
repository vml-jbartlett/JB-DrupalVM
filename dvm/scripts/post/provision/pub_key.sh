#!/usr/bin/env bash

 Install public key
cd /var/keys/public
if [ -e "id_rsa.pub" ]; then
    cd
    cat /var/keys/public/id_rsa.pub > .ssh/authorized_keys
else
    cd
fi
