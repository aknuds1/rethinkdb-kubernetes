FROM rethinkdb:2.4.0

MAINTAINER Arve Knudsen <arve.knudsen@gmail.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -yq curl && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

COPY ./run.sh ./probe /
RUN chmod u+x /run.sh /probe

ENTRYPOINT ["/usr/local/bin/dumb-init", "/run.sh"]
