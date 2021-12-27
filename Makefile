

all: zip

BUILDROOT_BRANCH = 2021.02.x

BUILDROOT_OPTIONS = BR2_EXTERNAL=$(PWD)/external

buildroot:
	git clone --single-branch --branch=$(BUILDROOT_BRANCH) \
	          --no-tags --depth=1 https://github.com/buildroot/buildroot

buildroot/.config: buildroot buildroot_defconfig kernel_defconfig
	cp buildroot_defconfig buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) olddefconfig

# buildroot/dl
download: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) source

.PHONY: clean
clean:
	rm -f buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) clean

img: output/disk.img
zip: output/disk.img.gz

# buildroot/output
output/disk.img: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/output/images/disk.img output/disk.img

output/disk.img.gz: output/disk.img
	cd output && gzip -9 >disk.img.gz <disk.img

disk.img:
	qemu-img convert -f raw -O qcow2 output/disk.img $@
	qemu-img resize $@ 20G

data.img:
	qemu-img create -f qcow2 $@ 5g

run: disk.img
	test -e /dev/kvm && kvm=-enable-kvm; \
	net="-net nic,model=virtio -net user"; \
	test -e data.img && hdb="-drive file=data.img,if=virtio,index=1,media=disk"; \
	test -e images.iso && hdd="-drive file=images.iso,if=virtio,index=3,media=cdrom"; \
	qemu-system-x86_64 $$kvm -M pc -smp 2 -m 2048 $$net \
	-drive file=disk.img,if=virtio,index=0,media=disk $$hdb $$hdd -boot c

graph-size.pdf:
	$(MAKE) -C buildroot graph-size
	cp buildroot/output/graphs/graph-size.pdf $@

graph-size.png: graph-size.pdf
	pdftoppm <$< | pnmtopng >$@

KUBEADM = kubeadm
DOCKER = docker

GOOS = linux
GOARCH = amd64

# /etc/kubernetes/flannel.yml
# https://raw.githubusercontent.com/coreos/flannel/v0.13.0/Documentation/kube-flannel.yml

images.txt:
	echo $$DOCKER
	$(KUBEADM) config images list > $@
	echo "quay.io/coreos/flannel:v0.13.0" >> $@

images: images.txt
	xargs -n 1 $(DOCKER) pull < $<
	for image in $$(cat $<); do \
	file=$$(echo $$image | sed -e 's/:/_/'); \
	mkdir -p images/$$(dirname $$file); \
	$(DOCKER) save $$image | pigz > images/$$file; done

images.tar: images.txt
	xargs -n 1 $(DOCKER) pull < $<
	xargs $(DOCKER) save < $< > $@

images.tgz: images.tar
	pigz < $< > $@

images.txz: images.tar
	pixz < $< > $@

images.iso: images.txt images.txz
	genisoimage -output $@ $^

PYTHON = python

FORMAT = '{{.VirtualSize}}'

sizes.txt: images.txt
	xargs -n 1 $(DOCKER) images --format $(FORMAT) < $< > $@

image-size.png: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

image-size.pdf: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

# reference board
pc_x86_64_bios: buildroot
	$(MAKE) -C buildroot pc_x86_64_bios_defconfig
	$(MAKE) -C buildroot world
	@mkdir -p output/images
	cp buildroot/output/images/bzImage output/images/
	cp buildroot/output/images/rootfs.ext2 output/images/
