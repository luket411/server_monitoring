#!/bin/bash

source /etc/environment

LOG_FILE="/data/status.log"
STATE_FILE="/data/last_alert"

log() {
  echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

check_ping() {
  ping -c 1 -W 5 "$TARGET" > /dev/null 2>&1
}

check_http() {
  curl -fsS --max-time 10 "$TARGET" > /dev/null 2>&1
}

perform_check() {
  if [ "$CHECK_TYPE" = "http" ]; then
    check_http
  else
    check_ping
  fi
}

log "Checking $TARGET"

success=0

for i in $(seq 1 "$RETRIES"); do
  if perform_check; then
    success=1
    break
  fi
  log "Attempt $i failed"
  sleep "$RETRY_DELAY"
done

if [ "$success" -eq 1 ]; then
  log "OK: $TARGET is reachable"
  exit 0
fi

log "FAIL: $TARGET is DOWN"

now=$(date +%s)
last_alert=0

if [ -f "$STATE_FILE" ]; then
  last_alert=$(cat "$STATE_FILE")
fi

if [ $((now - last_alert)) -lt "$ALERT_COOLDOWN" ]; then
  log "Alert skipped (cooldown active)"
  exit 0
fi

/app/send-warning.sh "$TARGET"

echo "$now" > "$STATE_FILE"
