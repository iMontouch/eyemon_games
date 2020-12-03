#!/bin/bash

set -e

cd /data

#cp -rf /data/config /tmp/feed-the-beast/config
if [ "$(ls -A $DIR)" ]; then
    echo "Skipping initial Serverinstallation\nIt seems to be already installed"
else
    cp -rf /tmp/feed-the-beast/* .
	echo "eula=true" > /data/eula.txt
	sed -i 's/enable-rcon=false/enable-rcon=true/g' /data/server.properties
	echo "rcon.port=25575" >> /data/server.properties
	echo "rcon.password=1337" >> /data/server.properties
	wget https://media.forgecdn.net/files/3106/504/Dynmap-3.1-beta5-forge-1.12.2.jar -o /data/mods/Dynmap-3.1-beta5-forge-1.12.2.jar
	wget https://dl.dropboxusercontent.com/s/3fuqise4uee9rt7/spark-forge.jar -o /data/mods/spark-forge.jar
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi

#if [[ -n "$MOTD" ]]; then
#	# buggy
#    #sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
#fi
#if [[ -n "$LEVEL" ]]; then
#	# seems to be buggy
#    #sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
#fi
#if [[ -n "$OPS" ]]; then
#	# ops.json is the way
#    #echo $OPS | awk -v RS=, '{print}' >> ops.txt
#fi

/bin/bash ServerStartLinux.sh
