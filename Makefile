

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

img: output/sdcard.img
zip: output/sdcard.img.zip

# buildroot/output
output/sdcard.img: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/output/images/sdcard.img output/sdcard.img

output/sdcard.img.zip: output/sdcard.img
	cd output && zip sdcard.img.zip sdcard.img

KUBEADM = kubeadm
DOCKER = docker

images.txt:
	$(KUBEADM) config images list > $@
	echo "quay.io/coreos/flannel:v0.12.0" >> $@

images.tar: images.txt
	xargs -n 1 $(DOCKER) pull --platform=linux/arm64 < $<
	xargs $(DOCKER) save --output $@ < $<

images.tar.gz: images.tar
	pigz < $< > $@

images.tar.xz: images.tar
	pixz < $< > $@

# reference board
raspberrypi3_64: buildroot
	$(MAKE) -C buildroot raspberrypi3_64_defconfig
	$(MAKE) -C buildroot world
	@mkdir -p output/images
	cp buildroot/output/images/boot.vfat output/images/
	cp buildroot/output/images/rootfs.ext4 output/images/
