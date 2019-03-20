FROM ubuntu:18.04

# Alias, DNS or IP of Elasticsearch host to be queried by Elastalert. Set in default Elasticsearch configuration file.
ENV ELASTICSEARCH_HOST elasticsearch
# Port Elasticsearch runs on
ENV ELASTICSEARCH_PORT 9200
# Number of replicas
ENV ELASTALERT_INDEX_REPLICAS 1

RUN apt-get update && apt-get upgrade -y \
    && apt-get -y install build-essential python-setuptools python2.7 python2.7-dev libffi-dev libssl-dev git tox curl python-pip git
RUN pip install --upgrade cryptography \
    && pip install elastalert \
    && git clone https://github.com/Nclose-ZA/elastalert_hive_alerter.git \
    && cd elastalert_hive_alerter \
    && python setup.py install \
    && cd .. \
    && rm -rf elastalert_hive_alerter
RUN mkdir /etc/elastalert \
    && useradd -ms /bin/bash elastalert \
    && chown elastalert:elastalert /etc/elastalert
COPY ./entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
USER elastalert
STOPSIGNAL SIGTERM

CMD /bin/bash /opt/entrypoint.sh
