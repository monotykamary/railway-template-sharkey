# Deploy and Host Sharkey on Railway

## About Hosting Sharkey

Sharkey is a feature-rich federated social platform in the Misskey family, with ActivityPub federation, reactions, custom emoji, rich notes, channels, and Mastodon-compatible APIs. This template deploys stable 2025.4.7 with a generated root account, private PostgreSQL, authenticated Redis, and durable media.

Sign in as `admin` with `SHARKEY_ADMIN_PASSWORD`.

## Common Use Cases

- Feature-rich federated communities
- Misskey-compatible social hosting
- ActivityPub and Mastodon-client access

## Dependencies for Sharkey Hosting

### Deployment Dependencies

Sharkey, PostgreSQL, and Redis each use a daily-backed-up volume. Railway provides HTTPS. A stable public domain is required for federation and must not be changed after launch.

### Implementation Details

The adapter runs upstream migrations, uses Sharkey's protected first-setup API to create the generated root account, persists local media, uses SQL full-text search without optional extensions, and authenticates Redis. Use one application replica.

## Why Deploy Sharkey on Railway?

Railway provides generated credentials, private networking, HTTPS, persistent storage, backups, health checks, and Git-driven updates.
