#!/bin/bash

KB_DASH=/opt/dashboards-0.4.1

cd $KB_DASH && ./load.sh $ES_HOST
cd $HOME && python -m SimpleHTTPServer
