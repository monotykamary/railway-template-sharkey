FROM docker.io/library/redis:8.2.9-alpine@sha256:30abb90e62f14b737010746def3ba99cc79fe19dcdb3d37b41f21fc62e7da19d
COPY entrypoint.sh /usr/local/bin/sharkey-redis-entrypoint
RUN chmod +x /usr/local/bin/sharkey-redis-entrypoint
ENTRYPOINT ["/usr/local/bin/sharkey-redis-entrypoint"]
