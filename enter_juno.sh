#!/bin/sh

# first build the builder container.
# docker is quite good at caching, it is ok to run this often
docker build -t x_eleven .

# hacks to connect container to host X server
# https://stackoverflow.com/a/25280523/1271937
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# forwards all arguments to the shell in the container
# if no arguments are given, we are dropped into a shell inside
docker run -ti -v $PWD:/src/ -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e AUTHORITY=$XAUTH x_eleven "$@"
