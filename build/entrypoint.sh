#!/bin/bash

set -e

# Required vars
required_vars=("TARGET" "DISCORD_WEBHOOK_URL")

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "ERROR: $var is not set"
    exit 1
  fi
done

# Defaults if not set
export RETRIES=${RETRIES:-3}
export RETRY_DELAY=${RETRY_DELAY:-5}
export ALERT_COOLDOWN=${ALERT_COOLDOWN:-1800}
export CHECK_TYPE=${CHECK_TYPE:-ping}
export CHECK_SCHEDULE=${CHECK_SCHEDULE:-"*/30 * * * *"}
export CLEANUP_SCHEDULE=${CLEANUP_SCHEDULE:-"0 3 * * *"}

# Write environment for scripts (ignore schedules which are not needed in scripts)
echo RETRIES=$RETRIES > /etc/environment
echo RETRY_DELAY=$RETRY_DELAY >> /etc/environment
echo ALERT_COOLDOWN=$ALERT_COOLDOWN >> /etc/environment
echo CHECK_TYPE=$CHECK_TYPE >> /etc/environment

# Generate cron file
cat > /etc/crontabs/root <<EOF
$CHECK_SCHEDULE /app/check-status.sh >> /data/cron.log 2>&1
$CLEANUP_SCHEDULE /app/cleanup-logs.sh >> /data/cron.log 2>&1
EOF

echo "Using schedules:"
echo "  CHECK_SCHEDULE=$CHECK_SCHEDULE"
echo "  CLEANUP_SCHEDULE=$CLEANUP_SCHEDULE"

crond -f -l 2
