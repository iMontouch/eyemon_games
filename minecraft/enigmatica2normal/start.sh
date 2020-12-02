#!/bin/bash

set -e

cd /data

#cp -rf /data/config /tmp/feed-the-beast/config
#cp -rf /tmp/feed-the-beast/* .

echo "eula=true" > /data/eula.txt

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

/bin/bash ServerStartLinux.sh
