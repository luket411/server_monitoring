#!/bin/bash

source /etc/environment

echo "[$(date)] Cleaning logs older than ${LOG_RETENTION} days..."

# Keep only the last $LOG_RETENTION daily logs
find "$LOG_DIR" -type f -name "status-*.log" -mtime +"$((${LOG_RETENTION} - 1))" -delete

echo "[$(date)] Cleanup complete."
