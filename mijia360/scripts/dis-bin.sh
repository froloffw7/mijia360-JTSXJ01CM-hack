#!/bin/sh

# Absolute path to this script is: <path>/<filename>
SCRIPT=$(readlink -f $0)
# Absolute path this script. <path>
SCRIPTS=`dirname $SCRIPT`
MCH_HOME=`dirname $SCRIPTS`

binary="$1"

if [ ! -f /tmp/dis-bin ]; then
  cp /sdcard/$(MCH_HOME)/bin/dis-bin /tmp/
  chmod +x /tmp/dis-bin
fi

echo "Disabling ${1##*/}"
if pgrep "${binary}" >/dev/null; then
    pkill "${binary}"
fi
if ! mount | grep -q "${binary}"; then
    mount --bind /tmp/dis-bin "${binary}"
fi
