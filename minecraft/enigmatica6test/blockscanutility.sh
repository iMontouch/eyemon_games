#! /bin/bash
modsupport_dir="/opt/minecraft/e6t/dynmap/renderdata/modsupport/"
destination_dir="/root/dynmapblockscan/renderdata/"
queue_mods_dir="/opt/minecraft/e6t/mods/disabled/"
done_mods_dir="/opt/minecraft/e6t/mods/done/"
mods_dir="/opt/minecraft/e6t/mods/"

#docker-compose enigmatica6test down


function copy_renderdata() {
  mv $modsupport_dir* $destination_dir
}

# testing
function test_renderdata() {
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap purgeworld world"
  sleep 5
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap fullrender world"
}

function activate_mod() {
  mv $1 $mods_dir
}

function is_dynmap_blockscan_finished() {
  if [[ $(docker-compose logs enigmatica6test 2>&1 | grep "Elements generated") ]]; then
    echo 1
  else
    echo 0
  fi
}

docker-compose down
docker-compose up -d

while is_dynmap_blockscan_finished != 1
do
  echo "waiting for dynmap blockscan to finish..."
  sleep 5
done

echo "dynmap blockscan finished!"

if is_dynmap_blockscan_finished; then
  echo "yes"
else
  echo "no"
fi

for filename in $queue_mods_dir ; do
    echo "$filename"
done




#copy_renderdata