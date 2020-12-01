#!/bin/sh
sudo mkdir /opt/minecraft/sf4
sudo chown 845:845 /opt/minecraft/sf4
cp server.properties /opt/minecraft/sf4/server.properties
cp settings.sh /opt/minecraft/sf4/settings.sh
cp whitelist.json /opt/minecraft/sf4/whitelist.json
cp ops.json /opt/minecraft/sf4/ops.json

docker-compose up -d