#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# Expand /dev/mmcblk0p2
printf "ROOT_DISK=/dev/mmcblk0\nROOT_PARTPREFIX=p\nROOT_PARTITION=2\n" > $TARGET_DIR/etc/disk-expand-root

# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

mkdir -p $TARGET_DIR/etc/systemd/network
ln -sf /dev/null $TARGET_DIR/etc/systemd/network/99-default.link

# https://www.freedesktop.org/software/systemd/man/systemd-getty-generator.html

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -sf /lib/systemd/system/getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/getty@tty1.service

mkdir -p $TARGET_DIR/etc/systemd/system/getty@.service.d
printf "[Service]\nTTYVTDisallocate=no\n" > $TARGET_DIR/etc/systemd/system/getty@.service.d/noclear.conf

mkdir -p $TARGET_DIR/etc/systemd/system/docker.service.d
