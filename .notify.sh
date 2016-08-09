#!/bin/bash
set -e
echo Running $0

. CI.conf

# http://www.unix.com/shell-programming-and-scripting/78384-bash-how-call-function-having-its-name-variable.html
msgFunc=(eval ${sendMsg})

function sendSlack {
  echo Entering $FUNCNAME
  local exitcode=$1; shift
  local msg=$@

  local icon=":x:"
  [[ $exitcode == 0 ]] && local icon=":white_check_mark:"

  docker run --rm -it superbuddy/slack-push \
    https://hooks.slack.com/services/$slackToken \
    $slackChannel \
    CI-bot \
    $icon \
    ${msg:0:3222} # character limit of slack, just a random nr atm
}

function sendEmail {
  local exitcode=$1; shift
  local msg=$@

  local subj="Failed"
  [[ $exitcode == 0 ]] && local subj="Pass"

  docker run --rm -it svlentink/mail \
    $toEmail \
    $fromEmail \
    $subj \
    $msg
}


if $notifyBySlack; then sendSlack "$@"; fi
if $notifyByEmail; then sendEmail "$@"; fi
exit 0
