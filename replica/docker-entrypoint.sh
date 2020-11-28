#!/bin/bash

if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "*:*:*:$PG_REPLICATION_USER:$PG_REPLICATION_PASSWORD" > ~/.pgpass

  chmod 0600 ~/.pgpass

  until ping -c 1 -W 1 "${PG_MASTER_HOST:?missing environment variable. PG_MASTER_HOST must be set}"; do
    echo "Waiting for ${PG_MASTER_HOST} to ping..."
    sleep 1
  done

  until pg_basebackup -h "${PG_MASTER_HOST}" -D "${PGDATA}" -U "${PG_REPLICATION_USER}" -vP -w -X stream; do
    echo "Waiting for ${PG_MASTER_HOST} to connect..."
    sleep 1
  done

  echo "host    replication     all             0.0.0.0/0               md5" >> "$PGDATA/pg_hba.conf"

  set -e

  cat > "${PGDATA}/recovery.conf" <<EOF
standby_mode = on
recovery_target_timeline = 'latest'
primary_conninfo = 'host=${PG_MASTER_HOST} port=${PG_MASTER_PORT:-5432} user=${PG_REPLICATION_USER} password=${PG_REPLICATION_PASSWORD}'
restore_command = 'cp /var/lib/postgresql/archivedir/%f %p'
EOF

  echo "${PGDATA}/recovery.conf created"

  chown postgres. "${PGDATA}" -R

  chmod 700 "${PGDATA}" -R
fi

exec "$@"
