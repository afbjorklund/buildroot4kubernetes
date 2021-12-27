#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

cp -f "$BOARD_DIR/grub-bios.cfg" "$TARGET_DIR/boot/grub/grub.cfg"

# Copy grub 1st stage to binaries, required for genimage
cp -f "$HOST_DIR/lib/grub/i386-pc/boot.img" "$BINARIES_DIR"

# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

mkdir -p $TARGET_DIR/etc/systemd/network
ln -sf /dev/null $TARGET_DIR/etc/systemd/network/99-default.link

# https://www.freedesktop.org/software/systemd/man/systemd-getty-generator.html

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -sf /lib/systemd/system/getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/getty@tty1.service

mkdir -p $TARGET_DIR/etc/systemd/system/getty@.service.d
printf "[Service]\nTTYVTDisallocate=no\n" > $TARGET_DIR/etc/systemd/system/getty@.service.d/noclear.conf

# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

mkdir -p $TARGET_DIR/etc/docker
cp $BOARD_DIR/daemon.json $TARGET_DIR/etc/docker

mkdir -p $TARGET_DIR/etc/systemd/system/docker.service.d
