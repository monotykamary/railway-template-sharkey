FROM docker.io/library/redis:8.2.1-alpine@sha256:987c376c727652f99625c7d205a1cba3cb2c53b92b0b62aade2bd48ee1593232
COPY entrypoint.sh /usr/local/bin/sharkey-redis-entrypoint
RUN chmod +x /usr/local/bin/sharkey-redis-entrypoint
ENTRYPOINT ["/usr/local/bin/sharkey-redis-entrypoint"]
