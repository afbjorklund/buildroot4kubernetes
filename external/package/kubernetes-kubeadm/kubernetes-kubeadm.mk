################################################################################
#
# kubernetes kubeadm
#
################################################################################

KUBERNETES_KUBEADM_VERSION = 1.24.0
KUBERNETES_KUBEADM_SITE = $(KUBERNETES_SITE)
KUBERNETES_KUBEADM_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
HOST_KUBERNETES_KUBEADM_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
KUBERNETES_KUBEADM_LICENSE = Apache-2.0
KUBERNETES_KUBEADM_LICENSE_FILES = LICENSE

KUBERNETES_KUBEADM_SOURCE = $(KUBERNETES_SOURCE)

KUBERNETES_KUBEADM_MAKE_ENV = \
	$(HOST_GO_COMMON_ENV) \
	GOCACHE="$(HOST_GO_TARGET_CACHE)"

# Extra "gnu" (or missing vendor) in triplet
# But only set variable when cross-compiling
ifeq ($(BR2_x86_64),y)
	KUBERNETES_KUBEADM_MAKE_ENV += KUBE_LINUX_AMD64_CC=x86_64-buildroot-linux-gnu-gcc
endif
ifeq ($(BR2_aarch64),y)
	KUBERNETES_KUBEADM_MAKE_ENV += KUBE_LINUX_ARM64_CC=aarch64-buildroot-linux-gnu-gcc
endif

define KUBERNETES_KUBEADM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(KUBERNETES_KUBEADM_MAKE_ENV) $(MAKE1) -C $(@D) generated_files CC="$(HOSTCC)"
	$(TARGET_MAKE_ENV) $(KUBERNETES_KUBEADM_MAKE_ENV) $(MAKE1) -C $(@D) all WHAT="cmd/kubeadm" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define KUBERNETES_KUBEADM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubeadm $(TARGET_DIR)/usr/bin
endef

define HOST_KUBERNETES_KUBEADM_BUILD_CMDS
	$(HOST_MAKE_ENV) $(KUBERNETES_KUBEADM_MAKE_ENV) $(MAKE1) -C $(@D) generated_files CC="$(HOSTCC)"
	$(HOST_MAKE_ENV) $(KUBERNETES_KUBEADM_MAKE_ENV) $(MAKE1) -C $(@D) all WHAT="cmd/kubeadm" KUBE_BUILD_PLATFORMS="$$(go env GOOS)/$(GO_GOARCH)" KUBE_CGO_OVERRIDES=kubeadm
endef

define HOST_KUBERNETES_KUBEADM_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/$$(go env GOOS)/$(GO_GOARCH)/kubeadm $(HOST_DIR)/bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
