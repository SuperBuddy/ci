#!/bin/bash
set -e

# this function adds a new entity to the upstream section
# this subjected file should only contain one upstream section
# which can be included in the main config file
# example file content:
# upstream example {
#   server localhost:8080 weight=3;
#   server localhost:8081;
# }
# more info: http://nginx.org/en/docs/http/load_balancing.html
function addToUpstreamFile {
  local entry=$1
  local nginxConfigFile=$2
  
  local bakFile=$nginxConfigFile.$(/bin/date --iso-8601=second).bak
  mv $nginxConfigFile $bakFile

  while read line
  do # loop all the relevent lines back into the config
    local firstWord=$(echo $line | awk '{print $1;}')
    case "$firstWord" in
      upstream)
        echo "$line" >> $nginxConfigFile
        ;;
      server)
        echo "  $line" >> $nginxConfigFile
        ;;
    esac
  done < "$bakFile"
  # append new upstream
  echo "  server "$entry";" >> $nginxConfigFile
  echo "}" >> $nginxConfigFile
}

addToUpstreamFile "$@"

exit 0
