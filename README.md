buildroot4kubernetes
====================

Build a minimal environment with Buildroot, enough for running kubeadm for Kubernetes.

So basically the "bigger brother" of boot2docker... Or a smaller version of minikube.iso.

Written by Anders Björklund (@afbjorklund)


Kernel
* namespaces
* cgroups
* overlayfs
* nat
* bridge
* conntrack
* vxlan

User
* systemd
* glibc (required by systemd)
* docker
* containerd (required by dockerd)
* bash
* iptables
* conntrack (required since 1.18)


![graph size](graph-size.png)


Flashable image:

```
97M	output/sdcard0.img.zip
```

Image layout:

```
Disk output/sdcard0.img: 582 MiB, 610271744 bytes, 1191937 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device              Boot Start     End Sectors  Size Id Type
output/sdcard0.img1 *        1   65536   65536   32M  c W95 FAT32 (LBA)
output/sdcard0.img2      65537 1191936 1126400  550M 83 Linux
```

Reference board:

`raspberrypi0w`

```
18M	output/images/boot.vfat
75M	output/images/rootfs.ext4
```
