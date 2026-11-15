# Dependency candidate — 2026-11-15

Keep Sharkey 2025.4.7 byte-identical and preserve its pinned PostgreSQL and Redis dependencies. Advance only Node.js 22.23.4 to 22.23.5 / Alpine 3.24 by exact digest. Node's official 2026-11-11 notes classify 22.23.5 as an LTS security release. The source application, database major, Redis version and authentication setup do not change.

All production FROM images remain exact version/digest pairs. Boat must prove administrative login, incorrect-password rejection, creation of a local-only note, and retention of that exact note ID/text through upgrade and redeploy without recreation. No external federation is attempted or certified by this check. Full Railway product validation remains required before release.
