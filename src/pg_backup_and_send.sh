#!/bin/bash

echo 'Start making pg backup...'
# Return if err
set -e
# get env from file (because of cron job runs script with no env)
export $(cat .env | xargs)
: "${PG_CONN_STR:?Environment variable PG_CONN_STR is required}"
: "${PG_PASS:?Environment variable PG_PASS is required}"
: "${TG_BOT_TOKEN:?Environment variable TG_BOT_TOKEN is required}"
: "${PG_BACKUP_TG_CHAT_ID:?Environment variable PG_BACKUP_TG_CHAT_ID is required}"
BACKUP_DIR="/backup"

DBS=$(PGPASSWORD=$PG_PASS psql -d $PG_CONN_STR -Atc "SELECT datname FROM pg_database WHERE datistemplate = false;")
#IFS=$'\n' read -r -a db_array <<< "$DBS"
for db in $DBS; do
  echo "Database: $db"
  FILE_NAME="pg_backup_${db}_$(date +%Y-%m-%d_%H-%M).sql"
  DB_CONN_STR="$PG_CONN_STR/$db"
  # === BACKUP ===
  echo "Dumping database from $DB_CONN_STR"
  #  --no-privileges \
  PGPASSWORD="$PG_PASS" pg_dump \
    --inserts \
    --no-owner \
    -d "$DB_CONN_STR" > "$BACKUP_DIR/$FILE_NAME"

  # === SEND TO TELEGRAM ===
  curl -F chat_id="$PG_BACKUP_TG_CHAT_ID" \
       -F document=@"$BACKUP_DIR/$FILE_NAME" \
       "https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument"
done

# === CLEANUP ===
rm "$BACKUP_DIR/$FILE_NAME"
echo 'Pg backup saved successfully!'