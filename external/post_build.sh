#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# https://www.freedesktop.org/software/systemd/man/systemd-getty-generator.html

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -sf /lib/systemd/system/getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/getty@tty1.service
