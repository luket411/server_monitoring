#!/bin/bash

source /etc/environment

LOG_DIR="/data"
DATE=$(date +%F)
LOG_FILE="$LOG_DIR/status-$DATE.log"
STATE_FILE="/data/last_alert"

mkdir -p "$LOG_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
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
