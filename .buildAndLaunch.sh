#!/bin/bash
set -e
echo Running $0

. CI.conf

function nextPortNr { # echo the next free port number
  local startPortNr=$1
  while [ -n "$(docker ps | grep $startPortNr)" ]
  do
    local startPortNr=$(($startPortNr+1))
  done
  echo $startPortNr
}

# get the next available port number
internalPortNr=$(nextPortNr $startPortNr)
./.launch.sh $internalPortNr
echo Launched on port $internalPortNr
./.addNewUpstreamNginx.sh "$buildContainer_network:$internalPortNr" $nginxUpstreamFile
echo Updated upstream to include new config
./.reloadReverseProxy.sh
echo Reloaded the reverse proxy

exit 0
