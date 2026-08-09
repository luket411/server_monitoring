# Uptime Monitor

A lightweight, self-hosted uptime monitoring system with Docker Compose and Discord webhook alerts.

It performs health checks every 30 minutes using either ICMP ping or HTTP requests, retries failures, rate-limits alerts, and stores logs on the host.

Based on the [ddmf structure](https://github.com/luket411/ddmf). To merge in the latest ddmf see [here.](#ddmf-migration-guide)

## Features

- Ping or HTTP health checks
- Retry logic to avoid false positives
- Rate-limited alerts to prevent spam
- Discord webhook notifications
- Persistent logs stored on the host filesystem
- Fully containerized with Docker Compose
- Configurable via `.env`

## Configuration

Copy the template and create a `.env` file in the project root and define the following values:

```env
# Target to monitor (IP or URL)
TARGET=https://example.com

# Discord webhook URL
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/xxx/yyy

# Check type: ping or http
CHECK_TYPE=http

# Retry settings
RETRIES=3
RETRY_DELAY=5

# Alert cooldown (seconds)
ALERT_COOLDOWN=1800

# Timezone
TZ=Europe/London
```

## Quick Start

1. Start the container:

```bash
docker compose up -d --build
```

2. View logs:

```bash
docker compose logs -f
```

Or view the status log directly:

```bash
tail -f data/status.log
```

## How It Works

- A cron job runs every 30 minutes inside the container.
- The service checks the configured target using either ping or HTTP.
- If the first check fails, it retries the request the configured number of times.
- If the target is still unreachable, it checks the cooldown window before sending a Discord alert.
- Monitoring activity is logged to `/data/status.log`.

## Discord Alerts

Alerts are delivered through a Discord webhook.

Example alert text:

```text
🚨 ALERT: https://example.com is DOWN at Mon Apr 13 12:00:00 2026
```

To configure Discord alerts:

1. Open your Discord server.
2. Navigate to Channel Settings → Integrations → Webhooks.
3. Create a webhook.
4. Paste the webhook URL into the `.env` file.

## Check Types

### `CHECK_TYPE=ping`

- Uses ICMP ping.
- Best for server or VPS monitoring.

### `CHECK_TYPE=http`

- Uses `curl` for HTTP requests.
- Best for websites, APIs, or health endpoints.

## Logs and State

Files stored in `data/`:

- `status.log` — full monitoring logs
- `cron.log` — cron execution logs
- `last_alert` — timestamp used for rate limiting

## Rate Limiting

Alerts are rate-limited to prevent repeated notifications.

- An alert is only sent once per cooldown window.
- Default cooldown: `1800` seconds (30 minutes).

## Retry Logic

The monitor retries failed checks before issuing an alert.

- `RETRIES` controls how many times to retry.
- `RETRY_DELAY` sets the delay between retries.

Example:

```env
RETRIES=3
RETRY_DELAY=5
```

## Docker Commands

Start the system:

```bash
docker compose up -d --build
```

Stop the system:

```bash
docker compose down
```

## Potential Upgrades

Consider adding:

- Discord embed support with richer status cards
- Recovery notifications when the target comes back online
- Support for monitoring multiple targets from a config file
- A continuous worker loop instead of cron
- Prometheus metrics endpoint

## ddmf migration guide

```bash
git checkout main
git pull

# If not already run
git remote add ddmf git@github.com:luket411/ddmf.git

git branch ddmf-migration
git fetch ddmf

git checkout ddmf-migration
git merge ddmf/ddmf-main

# Fix any conflicts

git push

# Then open a normal PR and merge
```