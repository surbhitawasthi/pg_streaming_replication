#!/bin/bash

set -e

echo "host    replication     all             0.0.0.0/0               md5" >> "$PGDATA/pg_hba.conf"

mkdir -p /var/lib/postgresql/archivedir

cat >> "${PGDATA}/postgresql.conf" <<EOF
wal_level = hot_standby
archive_mode = on
archive_command = 'test ! -f /var/lib/postgresql/archivedir/%f && cp %p /var/lib/postgresql/archivedir/%f'
max_wal_senders = 10
wal_keep_segments = 32
hot_standby = on
EOF

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
CREATE USER $PG_REPLICATION_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REPLICATION_PASSWORD';
EOSQL
