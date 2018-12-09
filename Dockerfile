FROM ubuntu:18.04

# Alias, DNS or IP of Elasticsearch host to be queried by Elastalert. Set in default Elasticsearch configuration file.
ENV ELASTICSEARCH_HOST elasticsearch
# Port Elasticsearch runs on
ENV ELASTICSEARCH_PORT 9200
# Number of replicas
ENV ELASTALERT_INDEX_REPLICAS 1

RUN apt-get update && apt-get upgrade -y \
    && apt-get -y install build-essential python-setuptools python2.7 python2.7-dev libssl-dev git tox curl
RUN easy_install pip \
    && git clone https://github.com/Yelp/elastalert.git \
    && cd /elastalert/ && pip install -r requirements.txt \
    && pip install python-dateutil==2.6.0 \
    && cd /elastalert/ && python setup.py install
RUN mkdir /etc/elastalert \
    && useradd -ms /bin/bash elastalert \
    && chown elastalert:elastalert /etc/elastalert
COPY ./entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
USER elastalert
STOPSIGNAL SIGTERM

CMD /bin/bash /opt/entrypoint.sh
