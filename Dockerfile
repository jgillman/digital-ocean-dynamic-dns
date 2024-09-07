FROM ubuntu:noble-20240801

# [optional] variable SRC_ARCHIVE_URL -> archive to download in container for running
# [optional] volume mounting for persistance -> /local/path/to/dir:/mnt

WORKDIR /apps

COPY get-dns.sh .
COPY update-dns.sh .

RUN chmod +x *.sh

RUN 'crontab -l > crontab_new'
RUN 'echo "*/30 * * * * /apps/update-dns.sh >/dev/null 2>&1" >> crontab_new'
RUN crontab crontab_new
RUN rm crontab_new

CMD [ cron, tail -f /var/log/cron.log ]
