#!/usr/bin/env bash

# Author: Chris Dornsife chris@dornsife.com
# This will run a build container and extract a binary.
# This doesn't require the use of a mount so it can be used
# in a build pipeline such as bitbucket.
set -e -o pipefail

PROJ=probe

HASH=`date +%s`
BUILD_NAME=${PROJ}-build-${HASH}

docker build -t ${BUILD_NAME} -f Dockerfile.build .
docker create --name ${BUILD_NAME} ${BUILD_NAME} /bin/true
docker cp ${BUILD_NAME}:/target/$PROJ ./$PROJ
docker rm ${BUILD_NAME}
docker rmi -f ${BUILD_NAME}

chmod +x $PROJ