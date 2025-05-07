FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y wget gnupg2 curl lsb-release cron && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-16 && \
    mkdir /backup

VOLUME /backup
ENTRYPOINT ["sh", "-c", "chmod +x /app/src/*.sh && /app/src/entrypoint.sh"]
