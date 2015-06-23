#!/bin/bash
#
# Usage:
#   ./zabbix-slack.sh $1 $2 $3
#     $1 ... To name on Slack (hash:channel_name, at:user_name)
#     $2 ... Title on Slack
#     $3 ... Message on Slack
#

WEBHOOK_URL='%SLACK_WEB_HOOK_URL%'
USERNAME='Zabbix'

LF=$(printf '\\\012_')
LF=${LF%_}

TO="$1"
SUBJECT="$2"
BODY="$3"
COLOR='#000000'

BODY=${BODY//
/}
BODY=${BODY//$LF/\\n}

if echo "${SUBJECT}" | grep 'RECOVERY'; then
    COLOR='#1e90ff'
elif echo "${SUBJECT}" | grep 'PROBLEM'; then
    COLOR='#cd0000'
elif echo "${SUBJECT}" | grep 'OK'; then
    COLOR='#008b00'
fi

if echo "${TO}" | grep '^hash:'; then
    TO=${TO/hash\:/#}
elif echo "${TO}" | grep '^at:'; then
    TO=${TO/at\:/@}
fi

payload="payload={\"channel\":\"${TO}\",\"username\":\"${USERNAME}\",\"attachments\":[{\"title\":\"${SUBJECT}\",\"text\":\"${BODY}\",\"color\":\"${COLOR}\"}]}"
payload=${payload//"/\\"}
curl -m 10 --data-urlencode "${payload}" $WEBHOOK_URL

exit 0
