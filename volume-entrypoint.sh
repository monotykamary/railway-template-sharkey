#!/bin/sh
set -eu
# Railway mounts hide build-time ownership. Change only the mount root, never
# recurse into existing media; then run the application as its original user.
media=/sharkey/files
if [ "$(id -u sharkey)" != 991 ] || [ "$(id -g sharkey)" != 991 ]; then
  echo 'Sharkey image must use UID/GID 991' >&2
  exit 1
fi
if [ -L "$media" ] || [ ! -d "$media" ]; then
  echo 'Sharkey media path must be a directory, not a symlink' >&2
  exit 1
fi
# A mounted root cannot be renamed by the unprivileged app. Require the exact
# mount point and never dereference the final component in the ownership step.
if ! awk '$5 == "/sharkey/files" {found=1} END {exit !found}' /proc/self/mountinfo; then
  echo 'Sharkey media path must be a mounted volume' >&2
  exit 1
fi
if [ "$(id -u)" = 0 ]; then
  chown -h "$(id -u sharkey):$(id -g sharkey)" "$media"
  exec su-exec sharkey:sharkey /sharkey/railway-entrypoint.sh
fi
if [ "$(id -u)" != 991 ] || [ "$(id -g)" != 991 ] || [ ! -w "$media" ]; then
  echo 'Sharkey media path is not writable by the Sharkey user' >&2
  exit 1
fi
exec /sharkey/railway-entrypoint.sh
