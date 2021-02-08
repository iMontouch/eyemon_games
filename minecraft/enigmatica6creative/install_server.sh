#!/bin/sh
docker build --tag enigmatica6:creative .
sudo mkdir -p /opt/minecraft/e6c
# lazy shit
sudo chmod -R 777 /opt/minecraft/e6c

docker-compose up -d