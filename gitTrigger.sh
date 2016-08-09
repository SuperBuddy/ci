#!/bin/bash
set -e
echo Running $0

. CI.conf

[[ ! -d $logDir ]] \
  && echo creating new log dir \
  && sudo mkdir $logDir \
  && sudo chown $USER $logDir

./js-tests.sh || echo js tests failed && exit 1

echo Running the status test before trying to launch new stuff
./status-tests.sh || echo server status tests failed && exit 1

echo Running buildAndLaunch
./.buildAndLaunch.sh || echo something went wrong when building and launching && exit 1

echo Running the status checks
./status-tests.sh || echo server status tests failed && exit 1

echo $0 completed successfully
exit 0
