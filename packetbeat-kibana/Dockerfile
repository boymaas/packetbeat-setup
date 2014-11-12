FROM ubuntu:14.04
MAINTAINER Boy Maas <boy.maas@gmail.com>

ENV ES_HOST localhost
ENV HOME /opt/kibana-3.1.0-packetbeat

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y -q install curl libpcap0.8 python2.7-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /usr/bin/python2.7 /usr/bin/python

# download kibana
RUN cd /opt && curl -L -O https://github.com/packetbeat/kibana/releases/download/v3.1.0-pb/kibana-3.1.0-packetbeat.tar.gz && \
    tar -xzvf kibana-3.1.0-packetbeat.tar.gz && \ 
    rm kibana-3.1.0-packetbeat.tar.gz

# load kibana dashboard
RUN cd /opt && curl -L -O https://github.com/packetbeat/dashboards/archive/v0.2.1.tar.gz && \
    tar xzvf v0.2.1.tar.gz && rm v0.2.1.tar.gz

ADD launch.sh /launch.sh

EXPOSE 8000
WORKDIR /opt/kibana-3.1.0-packetbeat/

CMD ["/bin/bash","-c","/launch.sh"]
