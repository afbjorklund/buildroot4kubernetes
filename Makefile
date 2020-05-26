

all: iso

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

# buildroot/output
iso: buildroot/.config
	$(MAKE) -C buildroot $(BUILDROOT_OPTIONS) all
	@mkdir -p output
	cp buildroot/output/images/rootfs.iso9660 output/buildroot.iso

disk.img:
	qemu-img create -f qcow2 $@ 40g

run: output/buildroot.iso disk.img
	test -e /dev/kvm && kvm=-enable-kvm; \
	net="-net nic,model=virtio -net user"; \
	qemu-system-x86_64 $$kvm -M pc -smp 2 -m 2048 $$net \
	-cdrom output/buildroot.iso -hda disk.img -boot d

# reference board
qemu_x86_64: buildroot
	$(MAKE) -C buildroot qemu_x86_64_defconfig
	$(MAKE) -C buildroot world
	@mkdir -p output/images
	cp buildroot/output/images/bzImage output/images/
	cp buildroot/output/images/rootfs.ext2 output/images/
