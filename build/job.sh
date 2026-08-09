#!/bin/bash
source /etc/environment
source /app/runtime-functions

# -- Your Task goes here, see the example below for a simple task which checks if the current minute is even or odd and sends a warning to discord if it is odd.

check_if_minute_even(){
  local minute
  minute=$(date +%M)
  if (( minute % 2 == 0 )); then
    return 0
  else
    return 1
  fi
}

success=0

log "Checking for even minute..."
if check_if_minute_even; then
  success=1
  log "Minute is even."
else
  log "Minute is odd."
fi

if [[ $success -eq 1 ]]; then
  log "Task completed successfully."
  exit 0
else
  log "Task failed."
fi

send-warning "Task failed due to odd minute."