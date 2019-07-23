FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y \
    && apt-get -y install build-essential python-setuptools python2.7 python2.7-dev libffi-dev libssl-dev git tox curl python-pip git
RUN pip install --upgrade cryptography \
    && pip install elastalert>=0.2.0b2 \
    && git clone https://github.com/Nclose-ZA/elastalert_hive_alerter.git \
    && cd elastalert_hive_alerter \
    && python setup.py install \
    && cd .. \
    && rm -rf elastalert_hive_alerter
RUN mkdir /etc/elastalert \
    && useradd -ms /bin/bash elastalert \
    && chown elastalert:elastalert /etc/elastalert
USER elastalert
STOPSIGNAL SIGTERM

CMD elastalert --config /etc/elastalert/config.yaml --verbose
