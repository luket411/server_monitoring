# ---------------------------------------------
# -- Global ddmf level environment variables --
# ---------------------------------------------

# -- cron format helper: https://en.wikipedia.org/wiki/Cron

# -- Main job frequency (cron format) (default: every 1 minutes)
JOB_SCHEDULE="*/1 * * * *"

# -- Log retention (in days)
LOG_RETENTION=3

# -- Discord webhook url
# DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...

TZ=Europe/London

# DISCORD_BOT_IDENTIFIER="NAS Uptime Monitor"

# ----------------------------------------------
# -- Container specific environment variables --
# ----------------------------------------------

CHECK_TYPE=http
RETRIES=3
RETRY_DELAY=5
ALERT_COOLDOWN=1800

# TARGET=http://localhost:8080
