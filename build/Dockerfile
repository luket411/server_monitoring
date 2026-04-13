FROM alpine:3.19

# Minimal runtime dependencies
RUN apk add --no-cache \
    bash \
    iputils \
    curl \
    ca-certificates \
    tzdata

WORKDIR /app

# Copy scripts
COPY check-status.sh /app/check-status.sh
COPY send-warning.sh /app/send-warning.sh
COPY entrypoint.sh /app/entrypoint.sh
COPY crontab /etc/crontabs/root

# Permissions
RUN chmod +x /app/*.sh

# Ensure log directory exists
RUN mkdir -p /data

CMD ["/app/entrypoint.sh"]
