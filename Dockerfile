FROM python:3.8.5-alpine

LABEL description="ElastAlert"
LABEL maintainer="Justin Henderson - Cloned from Jason Ertel's elastalert dockerfile"

ARG ELASTALERT_VERSION=0.2.4

RUN apk --update upgrade && \
    apk add gcc libffi-dev musl-dev openssl-dev tzdata libmagic git && \
    rm -rf /var/cache/apk/*

RUN pip install elastalert==${ELASTALERT_VERSION} && \
    apk del gcc libffi-dev musl-dev openssl-dev

RUN git clone https://github.com/Nclose-ZA/elastalert_hive_alerter.git \
    && cd elastalert_hive_alerter \
    && python setup.py install

RUN mkdir -p /opt/elastalert/config && \
    mkdir -p /opt/elastalert/rules && \
    echo "#!/bin/sh" >> /opt/elastalert/run.sh && \
    echo "set -e" >> /opt/elastalert/run.sh && \
    echo "elastalert-create-index --config /opt/config/elastalert_config.yaml" >> /opt/elastalert/run.sh && \
    echo "exec elastalert --config /opt/config/elastalert_config.yaml \"\$@\"" >> /opt/elastalert/run.sh && \
    chmod +x /opt/elastalert/run.sh

ENV TZ "UTC"

WORKDIR /opt/elastalert
ENTRYPOINT ["/opt/elastalert/run.sh"]
