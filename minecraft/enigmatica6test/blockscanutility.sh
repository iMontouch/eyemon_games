#! /bin/bash
server_root="/opt/minecraft/e6t"
modsupport_dir="$server_root/dynmap/renderdata/modsupport"
queue_mods_dir="$server_root/mods/disabled"
done_mods_dir="$server_root/mods/done"
mods_dir="$server_root/mods"
world_dir="$server_root/world"
destination_dir="/root/dynmapblockscan/renderdata"

#docker-compose enigmatica6test down

function copy_renderdata() {
  mkdir -p $destination_dir/"$1"
  cp $modsupport_dir/* $destination_dir/$1
  mv $modsupport_dir/* $destination_dir
}

# testing
function test_renderdata() {
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap purgeworld world"
  sleep 5
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap fullrender world"
}

function is_dynmap_blockscan_finished() {
  if [[ $(docker-compose logs enigmatica6test 2>&1 | grep "Elements generated") ]]; then
    return 1
  else
    return 0
  fi
}

function run_blockscan() {
  # Stop and Rerun Server
  docker-compose down
  docker-compose up -d

  echo "-> waiting for dynmap blockscan to finish..."
  while is_dynmap_blockscan_finished != 1; do
    sleep 5
  done

  # Stop Server as finished state is reached
  echo "-> Dynmap blockscan finished!"
  sleep 2
  docker-compose down
}

# Making sure the server is down before anything happens
docker-compose down
rm -r "$world"

for filename in $queue_mods_dir/*; do
  #echo "$filename"
  #echo "${filename##*/}"
  modname=${filename##*/}
  echo "Generating Dynmap Renderdata for Mod $modname"
  mv $queue_mods_dir/"$modname" $mods_dir
  run_blockscan
  copy_renderdata "$1"
  mv $mods_dir/"$modname" $done_mods_dir
done

#copy_renderdata
