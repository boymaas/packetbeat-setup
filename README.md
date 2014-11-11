# Docker image for Packetbeat setup #

Packetbeat is an open source application monitoring and
performance management (APM) system. See 
http://packetbeat.com for details.

This runs all necessary steps to have the Packetbeat stack (without the agent) on your host 
(Based on [Get Started](http://packetbeat.com/getstarted)) .

## How to use ##

To build:

     $ docker build -t packetbeat-setup .

To run:

     $ docker run -it --rm -v /var/run/docker.sock:/docker.sock -v /usr/local/bin:/scripts packetbeat-setup

To stop, start, restart, rm, pause, unpause, log, logf:

	$ packetbeat stop # or any of those listed above

## From docker hub ##

    $ docker pull tpires/packetbeat-setup
    $ docker run -it --rm -v /var/run/docker.sock:/docker.sock -v /usr/local/bin:/scripts tpires/packetbeat-setup

The `-v /var/run/docker.sock:/docker.sock` makes it possible to build images and run containers of your host
inside this docker image. The `-v /usr/local/bin:/scripts` copies packetbeat script that facilitates stop, start, restart, etc.

## Note ##

You still need to configure and execute packetbeat-agent. Read [this](https://github.com/packetbeat/packetbeat-docker).

## Thanks ##
* @tsg for building packetbeat-agent on docker and inspiring me to do this setup.