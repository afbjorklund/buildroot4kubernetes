#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

mkdir -p $TARGET_DIR/etc/systemd/network
ln -sf /dev/null $TARGET_DIR/etc/systemd/network/99-default.link

# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

mkdir -p $TARGET_DIR/etc/docker
cp $BOARD_DIR/daemon.json $TARGET_DIR/etc/docker

mkdir -p $TARGET_DIR/etc/systemd/system/docker.service.d
