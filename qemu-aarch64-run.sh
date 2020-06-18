qemu-system-aarch64 -M raspi3 -cpu cortex-a53 -m 256 -serial stdio -drive file=output/images/boot.vfat,index=0,if=sd,format=raw -drive file=output/images/rootfs.ext2,index=1,if=sd,format=raw
