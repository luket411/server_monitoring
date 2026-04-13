#!/bin/bash

set -e

required_vars=("TARGET" "DISCORD_WEBHOOK_URL")

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "ERROR: $var is not set"
    exit 1
  fi
done

export RETRIES=${RETRIES:-3}
export RETRY_DELAY=${RETRY_DELAY:-5}
export ALERT_COOLDOWN=${ALERT_COOLDOWN:-1800}
export CHECK_TYPE=${CHECK_TYPE:-ping}

printenv > /etc/environment

mkdir -p /data

crond -f -l 2
