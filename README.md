buildroot2kubernetes
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


Bootable image:

```
126M	output/buildroot.iso
```

Required images:

```console
$ kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.18.3
k8s.gcr.io/kube-controller-manager:v1.18.3
k8s.gcr.io/kube-scheduler:v1.18.3
k8s.gcr.io/kube-proxy:v1.18.3
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.3-0
k8s.gcr.io/coredns:1.6.7
```

`docker images`:

```
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                v1.18.3             3439b7546f29        11 days ago         117MB
k8s.gcr.io/kube-scheduler            v1.18.3             76216c34ed0c        11 days ago         95.3MB
k8s.gcr.io/kube-controller-manager   v1.18.3             da26705ccb4b        11 days ago         162MB
k8s.gcr.io/kube-apiserver            v1.18.3             7e28efa976bd        11 days ago         173MB
k8s.gcr.io/pause                     3.2                 80d28bedfe5d        3 months ago        683kB
k8s.gcr.io/coredns                   1.6.7               67da37a9a360        4 months ago        43.8MB
k8s.gcr.io/etcd                      3.4.3-0             303ce5db0e90        7 months ago        288MB
```

![image size](image-size.png)

`docker save | xz`:

```
154M    images.txz
```

```
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1       1    153.6 MiB    693.7 MiB  0.221  CRC64   images.txz
```

Reference board:

`qemu/x86_64`

```
4.3M	output/images/bzImage
3.9M	output/images/rootfs.ext2
```
