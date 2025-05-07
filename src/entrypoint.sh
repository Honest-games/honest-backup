#!/bin/sh

env > /app/src/.env

# debug launch
#cd /app/src
#sh ./pg_backup_and_send.sh

echo "Starting pg backup on schedule $PG_BACKUP_SCHEDULE"
crontab /app/src/crontab.txt
cron
touch /var/log/cron.log
tail -f /var/log/cron.log
