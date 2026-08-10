# ---------------------------------------------
# -- Global ddmf level environment variables --
# ---------------------------------------------

# -- cron format helper: https://en.wikipedia.org/wiki/Cron

# -- Main job frequency (cron format) (default: every 1 minutes)
JOB_SCHEDULE="*/1 * * * *"

# -- Log retention (in days)
LOG_RETENTION=4

# -- Discord webhook url
# DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...

TZ=Europe/London

DISCORD_BOT_IDENTIFIER="basic-ddmf-container"

# ----------------------------------------------
# -- Container specific environment variables --
# ----------------------------------------------
