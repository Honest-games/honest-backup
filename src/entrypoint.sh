#!/bin/sh

set -e -x

env > /app/src/.env

# debug launch
#cd /app/src
#sh ./pg_backup_and_send.sh

echo "Starting pg backup on schedule $PG_BACKUP_SCHEDULE"
sed "s|\${PG_BACKUP_SCHEDULE}|$PG_BACKUP_SCHEDULE|g" /app/src/crontab.txt > /app/src/crontab_resolved.txt
crontab /app/src/crontab_resolved.txt
cron
touch /var/log/cron.log
tail -f /var/log/cron.log
