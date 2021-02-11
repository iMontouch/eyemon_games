#! /bin/bash
server_root="/opt/minecraft/e6t"
modsupport_dir="$server_root/dynmap/renderdata/modsupport"
queue_mods_dir="$server_root/mods/disabled"
done_mods_dir="$server_root/mods/done"
mods_dir="$server_root/mods"
world_dir="$server_root/world"
destination_dir="/root/dynmapblockscan/renderdata"
log_file="/root/dynmapblockscan/scan.log"

#docker-compose enigmatica6test down

function copy_renderdata() {
  mkdir -p $destination_dir/"$1"
  mkdir -p $destination_dir/enigmatica6
  cp $modsupport_dir/* $destination_dir/$1
  mv $modsupport_dir/* $destination_dir/enigmatica6
}

# testing
function test_renderdata() {
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap purgeworld world"
  sleep 5
  docker exec -it enigmatica6test /bin/bash /data/rcon-connect.sh "dynmap fullrender world"
}

function is_dynmap_blockscan_finished() {
  if [[ $(docker-compose logs enigmatica6test 2>&1 | grep "Elements generated") ]]; then
    echo "---> Dynmap blockscan finished!" >>$log_file
    return 1
  else
    if [[ $(docker-compose ps | grep Up) ]]; then
      return 0
    else
      echo "-!-> Detected turned server before reaching finished state, continuing with next mod." >>$log_file
      echo $(docker-compose logs enigmatica6test 2>&1 | grep "not installed")
      return 1
    fi
  fi
}

function rendered_data() {
  if [[ $(ls -A $modsupport_dir) ]]; then
    echo 1
  else
    echo 0
  fi
}

function run_blockscan() {
  # Stop and Rerun Server
  docker-compose down
  docker-compose up -d

  echo "---> waiting for dynmap blockscan to finish..." >>$log_file
  while is_dynmap_blockscan_finished != 1; do
    sleep 5
  done

  # Stop Server as finished state is reached
  sleep 2
  docker-compose down
}

function prepare_blockscan() {
  rm -r "$world"
  modname=$1
  mv $queue_mods_dir/"$modname" $mods_dir
  run_blockscan
  copy_renderdata "$modname"
  mv $mods_dir/"$modname" $done_mods_dir
}

function run_single_mod() {
  for filename in $queue_mods_dir/*; do
    modname=${filename##*/}
    echo "-> Generating Dynmap Renderdata for Mod $modname" >>$log_file
	prepare_blockscan "$modname"
  done
}

function run_all_disabled_mods() {
  echo "-> Generating Dynmap Renderdata for all Mods in disabled Mods Dir" >>$log_file
	rm -r "$world"
	mv $queue_mods_dir/* $mods_dir
	run_blockscan
  cp $modsupport_dir/* $destination_dir/enigmatica6
}


# Making sure the server is down before anything happens
docker-compose down
rm -r "$world"


if [ $# -eq 1 ] && [ $1 = "all" ]; then
  run_all_disabled_mods
else
  run_single_mod
fi
