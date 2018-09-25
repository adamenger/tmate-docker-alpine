#!/bin/sh

# get tmate keys used for authenticating connections to the server
RSA=`ssh-keygen -l -f /etc/tmate-keys/ssh_host_rsa_key -E md5 2>&1 | cut -d\  -f 2 | sed s/MD5://`
ECDSA=`ssh-keygen -l -f /etc/tmate-keys/ssh_host_ecdsa_key -E md5 2>&1 | cut -d\  -f 2 | sed s/MD5://`

# print out config used for connecting to the server
echo Add this to your ~/.tmate.conf file
echo set -g tmate-server-host ${HOST:-<server ip/hostname>}
echo set -g tmate-server-port ${PORT:-<server port>}
echo set -g tmate-server-rsa-fingerprint   \"$RSA\"
echo set -g tmate-server-ecdsa-fingerprint   \"$ECDSA\"
echo set -g tmate-identity \"\"              # Can be specified to use a different SSH key.
