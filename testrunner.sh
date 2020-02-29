#!/bin/bash

IMAGE_NAME=server-image
CONTAINER_NAME=server-container

echo " --> Testing sample app"

set -e

function abort()
{
	echo "$@"
	exit 1
}

function cleanup()
{
	echo " --> Stopping container"
  docker container rm  ${CONTAINER_NAME} --force &>/dev/null
}

cd ./test-app

echo " --> Building test app image"
docker image build  -t ${IMAGE_NAME} . &>/dev/null
echo " --> Starting container"
docker container run --publish 8123:80 --detach --name ${CONTAINER_NAME} ${IMAGE_NAME} &>/dev/null

trap cleanup EXIT

echo " --> Running test"
RETVAL=$(curl -s -GET http://localhost:8123 | grep -c gke-nginx )

if [ $RETVAL -ne 1 ]; then
    abort "Test failed"
fi
