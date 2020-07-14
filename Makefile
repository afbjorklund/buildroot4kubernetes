

all: zip

BUILDROOT_BRANCH = 2020.02.x

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

img: output/sdcard0.img
zip: output/sdcard0.img.zip

# buildroot/output
output/sdcard0.img: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/output/images/sdcard0.img output/sdcard0.img

output/sdcard0.img.zip: output/sdcard0.img
	cd output && zip sdcardi0.img.zip sdcard0.img

KUBEADM = kubeadm
DOCKER = docker

GOOS = linux
GOARCH = arm

# /etc/kubernetes/flannel.yml
# https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml

images.txt:
	echo $$DOCKER
	$(KUBEADM) config images list > $@
	echo "quay.io/coreos/flannel:v0.12.0-$(GOARCH)" >> $@

images.tar: images.txt
	xargs -n 1 $(DOCKER) pull --platform=linux/arm < $<
	xargs $(DOCKER) save --output $@ < $<

images.tar.gz: images.tar
	pigz < $< > $@

images.tar.xz: images.tar
	pixz < $< > $@

PYTHON = python

FORMAT = '{{.VirtualSize}}'

sizes.txt: images.txt
	xargs -n 1 $(DOCKER) images --format $(FORMAT) < $< > $@

image-size.png: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

image-size.pdf: images.txt sizes.txt
	$(PYTHON) image-size.py $^ $@

# reference board
raspberrypi0w: buildroot
	$(MAKE) -C buildroot raspberrypi0w_defconfig
	$(MAKE) -C buildroot world
	@mkdir -p output/images
	cp buildroot/output/images/boot.vfat output/images/
	cp buildroot/output/images/rootfs.ext4 output/images/
