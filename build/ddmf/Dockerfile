FROM alpine:latest

# -- Minimal runtime dependencies, add dependencies if needed
RUN apk add --no-cache \
    bash \
    curl \
    tzdata

# -- Set workdir
WORKDIR /app

# -- Copy Scripts
COPY ddmf/cleanup-log.sh /app/cleanup-log.sh
COPY ddmf/entrypoint.sh /app/entrypoint.sh
COPY ddmf/runtime-functions /app/runtime-functions

COPY job.sh /app/job.sh

# -- Fix Permissions
RUN /app/*.sh

# -- Ensure log directory exists
RUN mkdir -p /logs

CMD ["/app/entrypoint.sh"]