# Third-party notices

Sharkey 2025.4.7: https://activitypub.software/TransFem-org/Sharkey/-/tags/2025.4.7 — AGPL-3.0-only. The application is copied unchanged from the exact official release image onto a pinned, maintained Node.js 22 / Alpine Linux runtime.

The official release image is published at `registry.activitypub.software/transfem-org/sharkey:2025.4.7`. That image is mirrored to `ghcr.io/monotykamary/sharkey:2025.4.7` for deploy reliability; the mirror is copied byte for byte, so its digest (`sha256:8857c9ded749bf6d1aa4f0e54095a0472f9d23a3dc39052c135f2b37881615d9`) matches the upstream digest exactly and the image contents are unmodified.

Node.js, Alpine Linux, FFmpeg, jemalloc, Redis, PostgreSQL, and their dependencies retain their upstream licenses. `assets/sharkey-icon.png` is upstream artwork.
