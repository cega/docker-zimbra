#!/bin/bash


export ZIMBRA_VER=${ZIMBRA_VER:-8.0}
export ZIMBRA_HOST=${ZIMBRA_HOST:-zimbra}
export ZIMBRA_DOMAIN=${ZIMBRA_DOMAIN:-out.ba.local}
export ZIMBRA_IMAGE=${ZIMBRA_IMAGE:-zimbra}
export ZIMBRA_PASSWORD=${ZIMBRA_PASSWORD:-password}
export ZIMBRA_SETUP=auto
export ZIMBRA_CLEANUP=yes
export ZIMBRA_UPGRADE=no
export CONTAINER_NAME=zimbra-instance-$ZIMBRA_HOST.$ZIMBRA_DOMAIN

build_img() {
 docker rmi -f $ZIMBRA_IMAGE
 docker build -t $ZIMBRA_IMAGE .
}


run_img() {
scripts/run_container.sh /bin/bash /start.sh
}

commit_img() {
docker rmi -f $CONTAINER_NAME:$ZIMBRA_VER
docker commit $CONTAINER_NAME $CONTAINER_NAME:$ZIMBRA_VER
}

build_img
run_img
commit_img

docker images | grep zimbra

