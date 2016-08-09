#!/bin/bash
set -e
echo Running $0

. CI.conf

portnr=$1
# specify which container to run
# this can also be a docker compose, which builds the container before running
docker run -d -p $portnr:$buildContainer_internalPort $buildContainer_name

exit 0
