FROM python:slim

LABEL maintainer="Paul Bargewell <paul.bargewell@opusvl.com>" \
    copyright="Copyright 2021, Opus Vision Limited T/A OpusVL" \
    SPDX-License-Identifier="AGPL-3.0-or-later"

ENV GNUHEALTH_PACKAGE https://ftp.gnu.org/gnu/health/gnuhealth-latest.tar.gz

ENV TRYTOND_DATABASE_URI "postgresql://${GNUHEALTH_POSTGRES_USER}:${GNUHEALTH_POSTGRES_PASSWORD}@db:5432"
ENV TRYTONPASSFILE /home/gnuhealth/.password

RUN useradd --uid 1000 --create-home --home-dir /home/gnuhealth gnuhealth

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        patch \
        vim \
        wget && \
    wget -q  --output-document=/tmp/gnuhealth.tgz "${GNUHEALTH_PACKAGE}" && \
    mkdir /tmp/gnuhealth && \
    cd /tmp/gnuhealth && \
    tar xzf /tmp/gnuhealth.tgz --strip-components=1 && \
    chown gnuhealth: /tmp/gnuhealth/ -R

USER gnuhealth

RUN cd /tmp/gnuhealth && \
    ./gnuhealth-setup install && \
    chmod +x /home/gnuhealth/start_gnuhealth.sh

USER root

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*    

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 8000 8080

USER gnuhealth

ENTRYPOINT [ "/docker-entrypoint.sh" ]

