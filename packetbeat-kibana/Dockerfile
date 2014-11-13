FROM ubuntu:14.04
MAINTAINER Boy Maas <boy.maas@gmail.com>

ENV ES_HOST localhost
ENV HOME /opt/packetbeat-0.4.0

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y -q install curl libpcap0.8 python2.7-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /usr/bin/python2.7 /usr/bin/python

# download kibana
RUN cd /opt && curl -L -O https://github.com/packetbeat/packetbeat/releases/download/v0.4.0/packetbeat-0.4.0-x86_64.tar.gz && \
    tar -xzvf packetbeat-0.4.0-x86_64.tar.gz && \ 
    rm packetbeat-0.4.0-x86_64.tar.gz

# load kibana dashboard
RUN cd /opt && curl -L -O https://github.com/packetbeat/dashboards/archive/v0.4.1.tar.gz && \
    tar xzvf v0.4.1.tar.gz && rm v0.4.1.tar.gz

ADD launch.sh /launch.sh

EXPOSE 8000
WORKDIR /opt/packetbeat-0.4.0

CMD ["/bin/bash","-c","/launch.sh"]
