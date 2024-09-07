FROM ubuntu:noble-20240801

# [optional] variable SRC_ARCHIVE_URL -> archive to download in container for running
# [optional] volume mounting for persistance -> /local/path/to/dir:/mnt

WORKDIR /apps

COPY Crontab /etc/cron.d/dyndns

COPY get-dns.sh .
COPY update-dns.sh .

RUN chmod +x *.sh

RUN apt-get update
RUN apt-get -y install cron
RUN apt-get -y install curl
RUN apt-get -y install jq

CMD [ cron, tail -f /var/log/cron.log ]
