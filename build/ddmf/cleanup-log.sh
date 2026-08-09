#!/bin/bash

source /etc/environment

echo "[$(date)] Cleaning logs older than 48 hours..."

# Keep only last 2 daily logs (today + yesterday)
find "$LOG_DIR" -type f -name "status-*.log" -mtime +2 -delete

echo "[$(date)] Cleanup complete."
