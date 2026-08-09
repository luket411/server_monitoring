#!/bin/bash

source /etc/environment

if [ -z "$1" ]; then
  echo "Usage: send-warning.sh <ALERT_TEXT>"
  exit 1
fi

ALERT_TEXT="$1"
MESSAGE="🚨 **ALERT ${DISCORD_BOT_IDENTIFIER}**: $ALERT_TEXT @ $(date '+%Y-%m-%d %H:%M:%S')"

curl -s -H "Content-Type: application/json" \
  -X POST \
  -d "{\"content\": \"$MESSAGE\"}" \
  "$DISCORD_WEBHOOK_URL"

