# ---------------------------------------------
# -- Global ddmf level environment variables --
# ---------------------------------------------

# -- cron format helper: https://en.wikipedia.org/wiki/Cron

# -- Main job frequency (cron format) (default: every 1 minutes)
JOB_SCHEDULE="*/1 * * * *"

# -- Cleanup schedule (cron format) (default: every day at 3am)
CLEANUP_SCHEDULE="0 3 * * *"

# -- Discord webhook url
# DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...

TZ=Europe/London

# DISCORD_BOT_IDENTIFIER=""

# ----------------------------------------------
# -- Container specific environment variables --
# ----------------------------------------------
