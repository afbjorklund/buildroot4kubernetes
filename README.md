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

Bootable image:

```
137M	output/disk.img.gz
```

Kubernetes bin:

```
38M     kubeadm
39M     kubectl
109M    kubelet
```

Required images:

```console
$ kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.20.0
k8s.gcr.io/kube-controller-manager:v1.20.0
k8s.gcr.io/kube-scheduler:v1.20.0
k8s.gcr.io/kube-proxy:v1.20.0
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns:1.7.0
```

`docker images`:

```
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                v1.20.0             10cc881966cf        2 weeks ago         118MB
k8s.gcr.io/kube-scheduler            v1.20.0             3138b6e3d471        2 weeks ago         46.4MB
k8s.gcr.io/kube-apiserver            v1.20.0             ca9843d3b545        2 weeks ago         122MB
k8s.gcr.io/kube-controller-manager   v1.20.0             b9fa1895dcaa        2 weeks ago         116MB
quay.io/coreos/flannel               v0.13.0             e708f4bb69e3        2 months ago        57.2MB
k8s.gcr.io/etcd                      3.4.13-0            0369cf4303ff        4 months ago        253MB
k8s.gcr.io/coredns                   1.7.0               bfe3a36ebd25        6 months ago        45.2MB
k8s.gcr.io/pause                     3.2                 80d28bedfe5d        10 months ago       683kB
```

![image size](image-size.png)

`docker pull` (gzip):

```
14M	images/k8s.gcr.io/coredns_1.7.0
82M	images/k8s.gcr.io/etcd_3.4.13-0
29M	images/k8s.gcr.io/kube-apiserver_v1.20.0
28M	images/k8s.gcr.io/kube-controller-manager_v1.20.0
47M	images/k8s.gcr.io/kube-proxy_v1.20.0
14M	images/k8s.gcr.io/kube-scheduler_v1.20.0
284K	images/k8s.gcr.io/pause_3.2
19M	images/quay.io/coreos/flannel_v0.13.0
230M	total
```

`docker save | xz`:

```
161M	images.txz
```

```
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1      48    166.5 MiB    745.0 MiB  0.224  CRC32   images.txz
```

Device layout:

| QEMU | File          | Media | Device   | Used for          | Size |
| ---- | ------------- | ----- | -------- | ----------------- | ---- |
| -hda | disk.img      | disk  | /dev/sda | Persistent `/var` |  20g |
| -hdb | data.img      | disk  | /dev/sdb | Persistent `/data`|   5g |
| -hdc | buildroot.iso | cdrom |          | Buildroot booting | 137m |
| -hdd | images.iso    | cdrom | /dev/sdc | Kubernetes images | 161m |

Reference board:

`pc` (bios)

```
4.9M	output/images/bzImage
84M	output/images/rootfs.ext2
```
