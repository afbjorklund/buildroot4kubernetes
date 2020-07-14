################################################################################
#
# k3s
#
################################################################################

K3S_VERSION = 1.18.4+k3s1
K3S_SITE = https://github.com/rancher/k3s/archive
K3S_LICENSE = Apache-2.0

K3S_SOURCE = v$(K3S_VERSION).tar.gz

K3S_MAKE_ENV = \
	$(GO_TARGET_ENV) \
	GO111MODULE=on

K3S_TAGS = ctrd apparmor no_btrfs netcgo osusergo providerless
K3S_LDFLAGS = -X github.com/rancher/k3s/pkg/version.Version=v$(K3S_VERSION) -w -s

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
K3S_OPTS += seccomp
K3S_DEPENDENCIES += libseccomp
endif

define K3S_BUILD_CMDS
	cd $(@D) && $(K3S_MAKE_ENV) \
	$(GO_BIN) build -mod vendor -tags "$(K3S_TAGS)" -ldflags "$(K3S_LDFLAGS)" -o bin/containerd ./cmd/server/main.go
	$(K3S_MAKE_ENV) make -C $(@D)/vendor/github.com/containerd/containerd bin/containerd-shim
	$(K3S_MAKE_ENV) make -C $(@D)/vendor/github.com/containerd/containerd bin/containerd-shim-runc-v2
endef

define K3S_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(K3S_PKGDIR)/k3s.sh $(TARGET_DIR)/usr/bin/k3s
	$(INSTALL) -D -m 0755 $(@D)/bin/containerd $(TARGET_DIR)/usr/bin
	ln -sf containerd $(TARGET_DIR)/usr/bin/k3s-agent
	ln -sf containerd $(TARGET_DIR)/usr/bin/k3s-server
	ln -sf containerd $(TARGET_DIR)/usr/bin/kubectl
	ln -sf containerd $(TARGET_DIR)/usr/bin/crictl
	ln -sf containerd $(TARGET_DIR)/usr/bin/ctr
	$(INSTALL) -D -m 0755 $(@D)/vendor/github.com/containerd/containerd/bin/containerd-shim $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/vendor/github.com/containerd/containerd/bin/containerd-shim-runc-v2 $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
