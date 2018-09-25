#!/bin/sh

set -e

# create keys if they don't exist
if [ ! -f /etc/tmate-keys/ssh_host_rsa_key ]; then
    echo "tmate keys not found, creating them..."
    /bin/sh /bin/create_keys.sh
    mv keys/* /etc/tmate-keys/
fi

# execute banner before startup
/bin/sh /bin/tmate-banner.sh 
sleep 3

exec "$@"
