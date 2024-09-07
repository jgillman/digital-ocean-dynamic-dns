FROM ubuntu:noble-20240801

WORKDIR /apps

# copy over the scripts
COPY get-dns.sh /apps/
COPY update-dns.sh /apps/
COPY timer-job.sh /apps/

# Set execution permissions
RUN chmod 0755 /apps/get-dns.sh
RUN chmod 0755 /apps/update-dns.sh
RUN chmod 0755 /apps/timer-job.sh

# install packages & then cleanup to minimize docker image
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install jq
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

CMD /apps/timer-job.sh

