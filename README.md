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
155M	output/disk.img.gz
```

Kubernetes bin:

```
43M     kubeadm
45M     kubectl
113M    kubelet
```

Required images:

```console
$ kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.21.0
k8s.gcr.io/kube-controller-manager:v1.21.0
k8s.gcr.io/kube-scheduler:v1.21.0
k8s.gcr.io/kube-proxy:v1.21.0
k8s.gcr.io/pause:3.4.1
k8s.gcr.io/etcd:3.4.13-0
k8s.gcr.io/coredns/coredns:v1.8.0
```

`docker images`:

```
REPOSITORY                           TAG                 IMAGE ID       CREATED         SIZE
k8s.gcr.io/kube-apiserver            v1.21.0             4d217480042e   2 weeks ago     126MB
k8s.gcr.io/kube-controller-manager   v1.21.0             09708983cc37   2 weeks ago     120MB
k8s.gcr.io/kube-scheduler            v1.21.0             62ad3129eca8   2 weeks ago     50.6MB
k8s.gcr.io/kube-proxy                v1.21.0             38ddd85fe90e   2 weeks ago     122MB
k8s.gcr.io/pause                     3.4.1               0f8457a4c2ec   3 months ago    683kB
k8s.gcr.io/etcd                      3.4.13-0            0369cf4303ff   8 months ago    253MB
k8s.gcr.io/coredns/coredns           v1.8.0              296a6d5035e2   6 months ago    42.5MB
quay.io/coreos/flannel               v0.13.0             e708f4bb69e3   6 months ago    57.2MB
```

![image size](image-size.png)

`docker pull` (gzip):

```
29M	images/k8s.gcr.io/kube-apiserver_v1.21.0
28M	images/k8s.gcr.io/kube-controller-manager_v1.21.0
14M	images/k8s.gcr.io/kube-scheduler_v1.21.0
47M	images/k8s.gcr.io/kube-proxy_v1.21.0
284K	images/k8s.gcr.io/pause_3.4.1
82M	images/k8s.gcr.io/etcd_3.4.13-0
13M	images/k8s.gcr.io/coredns/coredns_v1.8.0
19M	images/quay.io/coreos/flannel_v0.13.0
230M	total
```

`docker save | xz`:

```
161M	images.txz
```

```
Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename
    1      47    160.1 MiB    734.9 MiB  0.218  CRC32   images.txz
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
