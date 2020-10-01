#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # QEMU graphical window' ${TARGET_DIR}/etc/inittab
fi

# can't use pivot_root when running on rootfs, only when root is on e.g. tmpfs

mkdir -p $TARGET_DIR/etc/default
echo "export DOCKER_RAMDISK=true" > $TARGET_DIR/etc/default/dockerd
