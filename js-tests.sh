#!/bin/bash
set -e
echo Running $0

. CI.conf

logfile=$logDir/$(/bin/date --iso-8601=second)_js.log
exitcode=0
docker run -it --rm -v $repoLoc:/repo superbuddy/testnodejs &> $logfile || exitcode=1
echo exited with $exitcode, see $logfile

./.notify.sh $exitcode $(cat $logfile)

exit $exitcode
