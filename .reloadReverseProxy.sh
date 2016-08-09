#!/bin/bash
set -e
echo Running $0

. CI.conf

${nginxReloadCmd}

exit 0
