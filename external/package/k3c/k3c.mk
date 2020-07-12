################################################################################
#
# k3c
#
################################################################################

K3C_VERSION = 0.2.1
K3C_SITE = https://github.com/rancher/k3c/archive
K3C_LICENSE = Apache-2.0

K3C_SOURCE = v$(K3C_VERSION).tar.gz

K3C_TAGS = apparmor no_btrfs netgo osusergo
K3C_LDFLAGS = -X github.com/rancher/k3c/pkg/version.Version=v$(K3C_VERSION) -w -s

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
K3C_OPTS += seccomp
K3C_DEPENDENCIES += libseccomp
endif

define K3C_BUILD_CMDS
	cd $(@D) && $(GO_TARGET_ENV) GO111MODULE=on \
	$(GO_BIN) build -mod vendor -tags "$(K3C_TAGS)" -ldflags "$(K3C_LDFLAGS)" -o bin/k3c
endef

define K3C_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/k3c $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
