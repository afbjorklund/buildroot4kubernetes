#!/bin/sh

set -u
set -e

BOARD_DIR=$(dirname "$0")

# Detect boot strategy, EFI or BIOS
if [ -d "$BINARIES_DIR/efi-part/" ]; then
    cp -f "$BOARD_DIR/grub-efi.cfg" "$BINARIES_DIR/efi-part/EFI/BOOT/grub.cfg"
else
    cp -f "$BOARD_DIR/grub-bios.cfg" "$TARGET_DIR/boot/grub/grub.cfg"

    # Copy grub 1st stage to binaries, required for genimage
    cp -f "$TARGET_DIR/lib/grub/i386-pc/boot.img" "$BINARIES_DIR"
fi

# Expand /dev/vda1
printf "ROOT_DISK=/dev/vda\nROOT_PARTPREFIX=\nROOT_PARTITION=1\n" > $TARGET_DIR/etc/disk-expand-root

# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

mkdir -p $TARGET_DIR/etc/systemd/network
ln -sf /dev/null $TARGET_DIR/etc/systemd/network/99-default.link

# https://www.freedesktop.org/software/systemd/man/systemd-getty-generator.html

mkdir -p $TARGET_DIR/etc/systemd/system/getty.target.wants
ln -sf /lib/systemd/system/getty@.service $TARGET_DIR/etc/systemd/system/getty.target.wants/getty@tty1.service

mkdir -p $TARGET_DIR/etc/systemd/system/getty@.service.d
printf "[Service]\nTTYVTDisallocate=no\n" > $TARGET_DIR/etc/systemd/system/getty@.service.d/noclear.conf

mkdir -p $TARGET_DIR/etc/systemd/system/docker.service.d
