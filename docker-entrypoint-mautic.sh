#!/bin/bash
set -e

SECRET_DIR="/run/secrets/mautic"

# DB password (secret)
if [ -f "$SECRET_DIR/mautic_db_password" ]; then
  export MAUTIC_DB_PASSWORD="$(cat "$SECRET_DIR/mautic_db_password")"
fi

# Mailer DSN (secret)
if [ -f "$SECRET_DIR/mailer_dsn" ]; then
  export MAUTIC_MAILER_DSN="$(cat "$SECRET_DIR/mailer_dsn")"
fi

# Hand off to the original Mautic entrypoint if present
if [ -x /entrypoint.sh ]; then
  exec /entrypoint.sh "$@"
else
  exec "$@"
fi
