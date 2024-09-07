FROM ubuntu:noble-20240801

# [optional] variable SRC_ARCHIVE_URL -> archive to download in container for running
# [optional] volume mounting for persistance -> /local/path/to/dir:/mnt

WORKDIR /apps

COPY Crontab /etc/cron.d/dyndns

RUN chmod 0644 /etc/cron.d/dyndns

COPY get-dns.sh /apps/
COPY update-dns.sh /apps/

RUN chmod 0755 /apps/get-dns.sh
RUN chmod 0755 /apps/update-dns.sh

RUN apt-get update
RUN apt-get -y install cron
RUN apt-get -y install curl
RUN apt-get -y install jq

RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
