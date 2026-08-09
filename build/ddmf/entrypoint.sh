#!/bin/bash

set -e

# Required vars
required_vars=(
  "DISCORD_WEBHOOK_URL"
  )

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "ERROR: $var is not set"
    exit 1
  fi
done

# Write accesible environment variables for runtime stage
echo LOG_DIR=/logs >> /etc/environment
echo DISCORD_WEBHOOK_URL=$DISCORD_WEBHOOK_URL
echo DISCORD_BOT_IDENTIFIER=$DISCORD_BOT_IDENTIFIER >> /etc/environment
echo LOG_RETENTION=$LOG_RETENTION >> /etc/environment

CLEANUP_SCHEDULE="0 3 * * *"

# Generate cron file
cat > /etc/crontabs/root <<EOF
$JOB_SCHEDULE /app/job.sh >> /logs/cron.log 2>&1
$CLEANUP_SCHEDULE /app/cleanup-logs.sh >> /logs/cron.log 2>&1
EOF

echo "Using schedules:" > /logs/cron.log
echo "  JOB_SCHEDULE=$JOB_SCHEDULE" >> /logs/cron.log
echo "  CLEANUP_SCHEDULE=$CLEANUP_SCHEDULE" >> /logs/cron.log

crond -f -l 2
