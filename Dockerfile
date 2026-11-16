# The upstream release image is published only on the project's own Forgejo registry, which Railway's
# builders stall on. .github/workflows/mirror-sharkey-image.yml copies it to GHCR unchanged, so this
# digest is byte-identical to registry.activitypub.software/transfem-org/sharkey:2025.4.7.
FROM ghcr.io/monotykamary/sharkey:2025.4.7@sha256:8857c9ded749bf6d1aa4f0e54095a0472f9d23a3dc39052c135f2b37881615d9 AS sharkey
FROM docker.io/library/node:22.23.5-alpine3.24@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa534549940b8d73bde88481a
ARG UID=991
ARG GID=991
ENV COREPACK_DEFAULT_TO_LATEST=0 NODE_ENV=production LD_PRELOAD=/usr/lib/libjemalloc.so.2
RUN apk add --no-cache ca-certificates curl ffmpeg tini su-exec jemalloc pixman pango cairo libpng librsvg font-noto font-noto-cjk font-noto-thai \
 && corepack enable \
 && addgroup -g "$GID" sharkey \
 && adduser -D -u "$UID" -G sharkey -h /sharkey sharkey \
 && mkdir -p /sharkey/.config /sharkey/files \
 && chown -R sharkey:sharkey /sharkey
COPY --from=sharkey --chown=sharkey:sharkey /sharkey /sharkey
COPY --chown=sharkey:sharkey entrypoint.sh /sharkey/railway-entrypoint.sh
COPY --chmod=755 volume-entrypoint.sh /usr/local/bin/sharkey-volume-entrypoint
RUN chmod +x /sharkey/railway-entrypoint.sh \
 && cd /sharkey \
 && corepack install
USER root
WORKDIR /sharkey
EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/sharkey-volume-entrypoint"]
