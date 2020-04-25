#!/bin/bash

set -e

cd /data

cp -rf /tmp/feed-the-beast/* .
echo "eula=true" > eula.txt

cp /tmp/server.properties .

if [[ -n "$GAMEMODE" ]]; then
    sed -i "/gamemode\s*=/ c gamemode=$GAMEMODE" /data/server.properties
fi
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
