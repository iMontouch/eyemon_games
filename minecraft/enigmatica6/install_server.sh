#!/bin/sh
docker build --tag enigmatica6:1.0 .
sudo mkdir -p /opt/minecraft/e6
# lazy shit
sudo chmod -R 777 /opt/minecraft/e6

docker-compose up -d