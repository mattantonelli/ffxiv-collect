#!/usr/bin/env bash
set -euo pipefail

if [ -n "${DATABASE_HOST:-}" ]; then
  echo "Waiting for MariaDB at ${DATABASE_HOST}:${DATABASE_PORT:-3306}..."
  until mysqladmin ping \
    -h "${DATABASE_HOST}" \
    -P "${DATABASE_PORT:-3306}" \
    -u "${DATABASE_USERNAME}" \
    -p"${DATABASE_PASSWORD}" \
    --silent; do
    sleep 2
  done
  echo "MariaDB is ready."
fi

rm -f tmp/pids/server.pid

exec "$@"
