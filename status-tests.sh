#!/bin/bash
set -e
echo Running $0

. CI.conf

logfile=$logDir/$(/bin/date --iso-8601=second)_status.log
exitcode=0
docker run --rm -it -v $PWD/status-tests:/totest superbuddy/server-status &> $logfile || exitcode=1
echo exited with $exitcode, see $logfile

./.notify.sh $exitcode $(cat $logfile)

exit $exitcode
