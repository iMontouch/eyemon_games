#! /bin/bash
server_root="/opt/minecraft/e6t"
modsupport_dir="$server_root/dynmap/renderdata/modsupport"
queue_mods_dir="$server_root/mods/disabled"
done_mods_dir="$server_root/mods/done"
crashed_mods_dir="$server_root/mods/crashed"
mods_dir="$server_root/mods"
world_dir="$server_root/world"
destination_dir="/root/dynmapblockscan/renderdata"
log_file="/root/dynmapblockscan/scan.log"

crashed=0

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
    echo "---> Dynmap blockscan finished!" 2>&1 | tee $log_file
    crashed=0
    return 1
  else
    if [[ $(docker-compose ps | grep Up) ]]; then
      return 0
    else
      echo "-!-> Detected turned server before reaching finished state, continuing with next mod." 2>&1 | tee $log_file
      echo $(docker-compose logs enigmatica6test 2>&1 | grep "not installed") 2>&1 | tee $log_file
      crashed=1
      return 1
    fi
  fi
}

function run_blockscan() {
  # Stop and Rerun Server
  docker-compose down
  docker-compose up -d

  echo "---> waiting for dynmap blockscan to finish..." 2>&1 | tee $log_file
  while is_dynmap_blockscan_finished != 1; do
    sleep 5
  done

  # Stop Server as finished state is reached
  sleep 2
  docker-compose stop
}

function prepare_blockscan() {
  rm -r "$world"
  modname=$1
  mv $queue_mods_dir/"$modname" $mods_dir
  run_blockscan
	if crashed; then
	  mv $mods_dir/"$modname" $crashed_mods_dir
	  echo "-> Server Crashed while creating for $modname. Dependency Issue?" 2>&1 | tee $log_file
	else
	  mv $mods_dir/"$modname" $done_mods_dir
	  if [[ $(ls -A $modsupport_dir) ]]; then
      copy_renderdata "$modname"
    else
	    echo "-> Seems like no output was generated for this $modname." 2>&1 | tee $log_file
	  fi
	fi
}

function run_single_mod() {
  for filename in $queue_mods_dir/*; do
    modname=${filename##*/}
    echo "-> Generating Dynmap Renderdata for Mod $modname" 2>&1 | tee $log_file
	prepare_blockscan "$modname"
  done
}

function run_all_disabled_mods() {
  echo "-> Generating Dynmap Renderdata for all Mods in disabled Mods Dir" 2>&1 | tee $log_file
	rm -r "$world_dir"
	mv $queue_mods_dir/* $mods_dir
	run_blockscan
	if crashed; then
	  find $mods_dir -maxdepth 1 -type f -not -name "Dyn*" -name "*.jar" -exec mv {} $crashed_mods_dir \;
	  echo "-> Server Crashed while creating for bunch of mods." 2>&1 | tee $log_file
	else
	  find $mods_dir -maxdepth 1 -type f -not -name "Dyn*" -name "*.jar" -exec mv {} $done_mods_dir \;
	  if [[ $(ls -A $modsupport_dir) ]]; then
	    cp $modsupport_dir/* $destination_dir/enigmatica6
	  else
	    echo "-> Seems like no output was generated for this mods." 2>&1 | tee $log_file
	  fi
	fi
}


# Making sure the server is down before anything happens
docker-compose down
rm -r "$world_dir"


if [ $# -eq 1 ] && [ $1 = "all" ]; then
  run_all_disabled_mods
else
  run_single_mod
fi
