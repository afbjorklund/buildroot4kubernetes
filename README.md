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
176M	output/disk.img.gz
```

Flashable image:

aarch64
```
174M	output/sdcard.img.zip
```

Kubernetes bin:

```
43M	/usr/bin/kubeadm
44M	/usr/bin/kubectl
111M	/usr/bin/kubelet
```

Required images:

```console
$ kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.24.0
k8s.gcr.io/kube-controller-manager:v1.24.0
k8s.gcr.io/kube-scheduler:v1.24.0
k8s.gcr.io/kube-proxy:v1.24.0
k8s.gcr.io/pause:3.7
k8s.gcr.io/etcd:3.5.3-0
k8s.gcr.io/coredns/coredns:v1.8.6
```

`docker images`:

linux/amd64
```
REPOSITORY                           TAG        IMAGE ID       CREATED         SIZE
k8s.gcr.io/kube-apiserver            v1.24.0    529072250ccc   29 hours ago    130MB
k8s.gcr.io/kube-proxy                v1.24.0    77b49675beae   29 hours ago    110MB
k8s.gcr.io/kube-scheduler            v1.24.0    e3ed7dee73e9   29 hours ago    51MB
k8s.gcr.io/kube-controller-manager   v1.24.0    88784fb4ac2f   29 hours ago    119MB
k8s.gcr.io/pause                     3.7        221177c6082a   7 weeks ago     711kB
k8s.gcr.io/etcd                      3.5.3-0    aebe758cef4c   2 weeks ago     299MB
k8s.gcr.io/coredns/coredns           v1.8.6     a4ca41631cc7   6 months ago    46.8MB
k8s.gcr.io/pause                     3.6        6270bb605e12   9 months ago    683kB
flannelcni/flannel                   v0.17.0    9247abf08677   2 months ago    59.8MB
```

linux/arm64
```
REPOSITORY                           TAG        IMAGE ID       CREATED         SIZE
k8s.gcr.io/kube-apiserver            v1.24.0    b62a103951f4   2 weeks ago     126MB
k8s.gcr.io/kube-proxy                v1.24.0    66e1443684b0   2 weeks ago     106MB
k8s.gcr.io/kube-scheduler            v1.24.0    b81513b3bfb4   2 weeks ago     50MB
k8s.gcr.io/kube-controller-manager   v1.24.0    59fad34d4fe0   2 weeks ago     116MB
k8s.gcr.io/pause                     3.7        e5a475a03805   2 months ago    514kB
k8s.gcr.io/etcd                      3.5.3-0    a9a710bb96df   5 weeks ago     178MB
k8s.gcr.io/coredns/coredns           v1.8.6     edaa71f2aee8   7 months ago    46.8MB
k8s.gcr.io/pause                     3.6        7d46a07936af   9 months ago    484kB
flannelcni/flannel                   v0.17.0    a8fbfb17608d   2 months ago    61.8MB
```

![image size](image-size.png)

`docker pull` (gzip):

```
32M	images/k8s.gcr.io/kube-apiserver_v1.24.0
37M	images/k8s.gcr.io/kube-proxy_v1.24.0
15M	images/k8s.gcr.io/kube-scheduler_v1.24.0
29M	images/k8s.gcr.io/kube-controller-manager_v1.24.0
292K	images/k8s.gcr.io/pause_3.7
97M	images/k8s.gcr.io/etcd_3.5.3-0
13M	images/k8s.gcr.io/coredns/coredns_v1.8.6
19M	images/docker.io/flannelcni/flannel_v0.17.0
240M	total
```

`docker save | xz`:

```
166M	images.txz
```

```
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1      50    165.4 MiB    776.0 MiB  0.213  CRC32   images.txz
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
