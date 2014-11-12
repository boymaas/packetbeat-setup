#!/bin/bash
NAME=packetbeat-setup
DOCKER_HOST=${DOCKER_HOST:-}
ACTION=${1:-make}
ES_PORT_REST=${ES_PORT_REST:-9200}
ES_PORT_NATIVE=${ES_PORT_NATIVE:-9300}
KIBANA_PORT=${ES_PORT:-8000}

if [ ! -e "/docker.sock" ] ; then
    echo "You must map your Docker socket to /docker.sock (i.e. -v /var/run/docker.sock:/docker.sock)"
    exit 1
fi

function cleanup {
	echo "
	Stopping packetbeat images...
  "

  for CNT in pbelastic pbkibana
  do
          docker -H unix:///docker.sock kill $CNT > /dev/null 2>&1
          docker -H unix:///docker.sock rm $CNT > /dev/null 2>&1
  done

  docker -H unix:///docker.sock rmi packetbeat-kibana > /dev/null 2>&1
}

function clean_garbage {
	# clean old images left behind
	docker -H unix:///docker.sock rmi `docker -H unix:///docker.sock images -q -f dangling=true` >&- 2>&-
}

function add_scripts () {
  mkdir -p /scripts >/dev/null && \
  cp -f $HOME/scripts/* /scripts/ >/dev/null
}

function wait_for_elastic() {
  until `docker -H unix:///docker.sock logs pbelastic | grep -i "started" &> /dev/null`; do
    sleep 1
  done
}

if [ "$ACTION" == "make" ] ; then

  add_scripts

  if [[ `docker -H unix:///docker.sock images packetbeat-kibana | wc -l` -eq 1 ]]; then
    echo "
    Building Packetbeat Kibana image, please wait...
    "    
    cd $HOME/packetbeat-kibana/ && docker -H unix:///docker.sock build -t packetbeat-kibana . >/dev/null
  fi  

  echo "
  Starting Packetbeat images, please wait...
  "

  if [[ `docker -H unix:///docker.sock ps | grep -i "pbelastic" | wc -l` -eq 0 ]]; then
    docker -H unix:///docker.sock run --name pbelastic -d -p $ES_PORT_REST:$ES_PORT_REST -p $ES_PORT_NATIVE:$ES_PORT_NATIVE dockerfile/elasticsearch >/dev/null
    wait_for_elastic
  fi

  ES_IP=`docker -H unix:///docker.sock inspect --format '{{ .NetworkSettings.IPAddress }}' pbelastic`
  curl -XPUT 'http://'$ES_IP':'$ES_PORT_REST'/_template/packetbeat' -d@$HOME/packetbeat.template.json >&- 2>&-

  if [[ `docker -H unix:///docker.sock ps | grep -i "pbkibana" | wc -l` -eq 0 ]]; then
    docker -H unix:///docker.sock run -d --name pbkibana -e ES_HOST=$ES_IP -p $KIBANA_PORT:$KIBANA_PORT packetbeat-kibana >/dev/null
  fi

  clean_garbage

  echo "
  If you haven't started packetbeat-agent yet, you can start it now.
  Read https://github.com/packetbeat/packetbeat-docker .
  "

elif [ "$ACTION" == "cleanup" ] ; then

  cleanup
  clean_garbage

  echo "
  Warning: Elasticsearch image wasn't removed. You have to remove it manually!
  "
fi
