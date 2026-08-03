#!/bin/sh
set -eu
: "${DOMAIN:?DOMAIN is required}" "${DB_HOST:?DB_HOST is required}" "${DB_PASS:?DB_PASS is required}" "${REDIS_HOST:?REDIS_HOST is required}" "${REDIS_PASS:?REDIS_PASS is required}" "${SHARKEY_ADMIN_PASSWORD:?SHARKEY_ADMIN_PASSWORD is required}"
mkdir -p /sharkey/.config /sharkey/files
cat >/sharkey/.config/default.yml <<EOF
url: '${PUBLIC_SCHEME:-https}://${DOMAIN}/'
setupPassword: '${SHARKEY_ADMIN_PASSWORD}'
port: 3000
db:
  host: '${DB_HOST}'
  port: ${DB_PORT:-5432}
  db: '${DB_NAME:-sharkey}'
  user: '${DB_USER:-sharkey}'
  pass: '${DB_PASS}'
dbReplications: false
redis:
  host: '${REDIS_HOST}'
  port: ${REDIS_PORT:-6379}
  family: 0
  pass: '${REDIS_PASS}'
fulltextSearch:
  provider: sqlLike
id: 'aidx'
clusterLimit: 1
mediaDirectory: /sharkey/files
proxyRemoteFiles: true
signToActivityPubGet: true
attachLdSignatureForRelays: true
websocketCompression: false
EOF
/sbin/tini -- pnpm run migrateandstart &
app=$!
trap 'kill -TERM "$app" 2>/dev/null || true; wait "$app"' TERM INT
ready=0
for i in $(seq 1 300); do
  if curl -fsS -X POST -H 'Content-Type: application/json' -d '{}' http://127.0.0.1:3000/api/meta >/tmp/sharkey-meta 2>/dev/null; then ready=1; break; fi
  sleep 2
done
[ "$ready" = 1 ] || { kill -TERM "$app" 2>/dev/null || true; wait "$app" || true; exit 1; }
if node -e "process.exit(JSON.parse(require('fs').readFileSync('/tmp/sharkey-meta','utf8')).requireSetup ? 0 : 1)"; then
  body=$(printf '{"username":"admin","password":"%s","setupPassword":"%s"}' "$SHARKEY_ADMIN_PASSWORD" "$SHARKEY_ADMIN_PASSWORD")
  curl -fsS -X POST -H 'Content-Type: application/json' --data "$body" http://127.0.0.1:3000/api/admin/accounts/create >/tmp/sharkey-admin
  grep -q '"token"' /tmp/sharkey-admin
fi
wait "$app"
