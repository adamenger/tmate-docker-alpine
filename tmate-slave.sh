#!/bin/sh
if [ -n "${HOST}" ]; then
  hostopt="-h ${HOST}"
fi
exec /bin/tmate-slave $hostopt -p ${PORT:-2222} -k /etc/tmate-keys 2>&1
