#!/bin/sh
#docker build --tag enigmatica6:creative .
sudo mkdir -p /opt/minecraft/e6t
# lazy shit
sudo chmod -R 777 /opt/minecraft/e6t

docker-compose up -d