#!/bin/bash

source /etc/environment

if [ -z "$TARGET" ]; then
  echo "Usage: send-warning.sh <target>"
  exit 1
fi

MESSAGE="🚨 **ALERT**: $TARGET is DOWN at $(date)"

curl -s -H "Content-Type: application/json" \
  -X POST \
  -d "{\"content\": \"$MESSAGE\"}" \
  "$DISCORD_WEBHOOK_URL"

