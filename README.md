buildroot4kubernetes
====================

Build a minimal environment with Buildroot, enough for running kubeadm for Kubernetes.

So basically the "bigger brother" of boot2docker... Or a smaller version of minikube.iso.

Interface            | Implementation | Notes
---------            | -------------- | -----
Container Runtime    | docker         | `cri-dockerd`*
Container Networking | flannel        | VXLAN backend
Container Storage    | nfs            | ReadWriteMany

\* Needed for Kubernetes 1.24 and later only

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

Bootable image:

x86_64
```
192M	output/disk.img.gz
```

Flashable image:

aarch64
```
174M	output/sdcard.img.zip
```

Kubernetes bin:

```
45M	/usr/bin/kubeadm
46M	/usr/bin/kubectl
116M	/usr/bin/kubelet
```

Required images:

```console
$ kubeadm config images list
registry.k8s.io/kube-apiserver:v1.26.0
registry.k8s.io/kube-controller-manager:v1.26.0
registry.k8s.io/kube-scheduler:v1.26.0
registry.k8s.io/kube-proxy:v1.26.0
registry.k8s.io/pause:3.9
registry.k8s.io/etcd:3.5.6-0
registry.k8s.io/coredns/coredns:v1.9.3
```

Additional images:

```
docker.io/flannelcni/flannel:v0.20.2
```

![image size](image-size.png)

`docker pull` (gzip):

```
33M	images/registry.k8s.io/kube-apiserver_v1.26.0
31M	images/registry.k8s.io/kube-controller-manager_v1.26.0
17M	images/registry.k8s.io/kube-scheduler_v1.26.0
21M	images/registry.k8s.io/kube-proxy_v1.26.0
304K	images/registry.k8s.io/pause_3.9
97M	images/registry.k8s.io/etcd_3.5.6-0
14M	images/registry.k8s.io/coredns/coredns_v1.9.3
20M	images/docker.io/flannelcni/flannel_v0.20.2
230M	total
```

`docker save | xz`:

```
159M	images.txz
```

```
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1      48    158,2 MiB    745,9 MiB  0,212  CRC32   images.txz
```

Device layout:

| QEMU | File          | Media | Device   | Used for          | Size |
| ---- | ------------- | ----- | -------- | ----------------- | ---- |
| -hda | disk.img      | disk  | /dev/sda | Persistent `/var` |  20g |
| -hdb | data.img      | disk  | /dev/sdb | Persistent `/data`|   5g |
| -hdc | buildroot.iso | cdrom |          | Buildroot booting | 137m |
| -hdd | images.iso    | cdrom | /dev/sdc | Kubernetes images | 160m |

Reference board:

`pc` (bios)

```
4.9M	output/images/bzImage
84M	output/images/rootfs.ext2
```

`raspberrypi3-64`

```
18M    output/images/boot.vfat
75M    output/images/rootfs.ext4
```
