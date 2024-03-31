

all: zip

BUILDROOT_BRANCH = 2023.02.x

KUBERNETES_VERSION = v1.26.0

# Kubernetes requires go1.21 or greater.
BUILDROOT_OVERRIDES += GO_VERSION=1.21.8

# Docker needs some security upgrades.
#BUILDROOT_OVERRIDES += DOCKER_CLI_VERSION=23.0.5
#BUILDROOT_OVERRIDES += DOCKER_ENGINE_VERSION=23.0.5
#BUILDROOT_OVERRIDES += CONTAINERD_VERSION=1.6.22
#BUILDROOT_OVERRIDES += RUNC_VERSION=1.1.12

BUILDROOT_OPTIONS = BR2_EXTERNAL=$(PWD)/external $(BUILDROOT_OVERRIDES)

buildroot:
	git clone --single-branch --branch=$(BUILDROOT_BRANCH) \
	          --no-tags --depth=1 https://github.com/buildroot/buildroot

.PHONY: override
override:
	@for pkg in go cni-plugins docker-cli docker-engine containerd runc; do \
	cp $(PWD)/external/override/$$pkg/* buildroot/package/$$pkg/; done

BUILDROOT_MACHINE = $(shell uname -m | sed -e 's/arm64/aarch64/')

BUILDROOT_TARGET = kubernetes_$(BUILDROOT_MACHINE)_defconfig

buildroot/.config: buildroot override $(BUILDROOT_CONFIG)
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) $(BUILDROOT_TARGET)

# buildroot/dl
download: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) source

.PHONY: clean
clean:
	rm -f buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) clean

ifeq ($(BUILDROOT_MACHINE),x86_64)
img: output/disk.img
zip: output/disk.img.gz
endif
ifeq ($(BUILDROOT_MACHINE),aarch64)
img: output/sdcard.img
zip: output/sdcard.img.zip
endif

O ?= output

# buildroot/output
output/disk.img: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/$(O)/images/disk.img output/disk.img
output/sdcard.img: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/$(O)/images/sdcard.img output/sdcard.img

output/disk.img.gz: output/disk.img
	cd output && gzip -9 >disk.img.gz <disk.img
output/sdcard.img.zip: output/sdcard.img
	cd output && zip sdcard.img.zip sdcard.img

disk.img:
	qemu-img convert -f raw -O qcow2 output/disk.img $@
	qemu-img resize $@ 20G

data.img:
	qemu-img create -f qcow2 $@ 5g

run: disk.img
	test -e /dev/kvm && kvm=-enable-kvm; \
	net="-net nic,model=virtio -net user,hostfwd=tcp:127.0.0.1:6443-:6443"; \
	test -e data.img && hdb="-drive file=data.img,if=virtio,index=1,media=disk"; \
	test -e images.iso && hdd="-drive file=images.iso,if=virtio,index=3,media=cdrom"; \
	qemu-system-x86_64 $$kvm -M pc -smp 2 -m 2048 $$net \
	-drive file=disk.img,if=virtio,index=0,media=disk $$hdb $$hdd -boot c

graph-size.pdf:
	$(MAKE) -C buildroot graph-size
	cp buildroot/$(O)/graphs/graph-size.pdf $@

graph-size.png: graph-size.pdf
	pdftoppm <$< | pnmtopng >$@

# https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubeadm
# make images.txt KUBEADM="./kubeadm --kubernetes-version=$KUBERNETES_VERSION"

KUBEADM = kubeadm
DOCKER = docker

ifeq ($(BUILDROOT_MACHINE),x86_64)
GOOS = linux
GOARCH = amd64
endif
ifeq ($(BUILDROOT_MACHINE),aarch64)
GOOS = linux
GOARCH = arm64
endif

# /etc/kubernetes/flannel.yml
# https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

images.txt:
	echo $(DOCKER)
	$(KUBEADM) config images list > $@
	echo "docker.io/flannelcni/flannel:v0.20.2" >> $@

images: images.txt
	xargs -n 1 $(DOCKER) pull --platform=$(GOOS)/$(GOARCH) < $<
	for image in $$(cat $<); do \
	file=$$(echo $$image | sed -e 's/:/_/'); \
	mkdir -p images/$$(dirname $$file); \
	$(DOCKER) save $$image | pigz > images/$$file; done

images.tar: images.txt
	xargs -n 1 $(DOCKER) pull --platform=$(GOOS)/$(GOARCH) < $<
	xargs $(DOCKER) save < $< > $@

images.tar.gz: images.tar
	gzip -9 < $< > $@

images.tar.xz: images.tar
	xz < $< > $@

images.tgz: images.tar
	pigz < $< > $@

images.txz: images.tar
	pixz < $< > $@

images.iso: images.txt images.txz
	genisoimage -output $@ $^

PYTHON = python

FORMAT = '{{.VirtualSize}}'

sizes.txt: images.txt
	#xargs -n 1 $(DOCKER) images --format $(FORMAT) < $< > $@
	@rm -f $@; for image in $$(cat $<); do \
	test "$(DOCKER)" = "docker" && image=$$(echo $$image | sed -e 's|docker.io/||'); \
	$(DOCKER) images --format $(FORMAT) $$image >> $@; done

image-size.png: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

image-size.pdf: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

# reference board
ifeq ($(BUILDROOT_MACHINE),x86_64)
pc_x86_64_bios: buildroot
	$(MAKE) -C buildroot pc_x86_64_bios_defconfig
	$(MAKE) -C buildroot world
	@mkdir -p output/images
	cp buildroot/$(O)/images/bzImage output/images/
	cp buildroot/$(O)/images/rootfs.ext2 output/images/
endif
ifeq ($(BUILDROOT_MACHINE),aarch64)
raspberrypi3_64: buildroot
	$(MAKE) -C buildroot raspberrypi3_64_defconfig
	cp buildroot/$(O)/images/boot.vfat output/images/
	cp buildroot/$(O)/images/rootfs.ext4 output/images/
endif
