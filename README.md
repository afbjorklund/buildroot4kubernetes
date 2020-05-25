buildroot2kubernetes
====================

Build a minimal environment with Buildroot, enough for running kubeadm for Kubernetes.

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


Reference board:

`qemu/x86_64`

```
4.3M	output/images/bzImage
3.9M	output/images/rootfs.ext2
```
