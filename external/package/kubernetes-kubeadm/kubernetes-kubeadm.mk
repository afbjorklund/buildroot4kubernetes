################################################################################
#
# kubernetes kubeadm
#
################################################################################

KUBERNETES_KUBEADM_VERSION = 1.23.0
KUBERNETES_KUBEADM_SITE = $(KUBERNETES_SITE)
KUBERNETES_KUBEADM_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
KUBERNETES_KUBEADM_LICENSE = Apache-2.0
KUBERNETES_KUBEADM_LICENSE_FILES = LICENSE

KUBERNETES_KUBEADM_SOURCE = $(KUBERNETES_SOURCE)

define KUBERNETES_KUBEADM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) generated_files
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all WHAT="cmd/kubeadm" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define KUBERNETES_KUBEADM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubeadm $(TARGET_DIR)/usr/bin
endef

define HOST_KUBERNETES_KUBEADM_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) generated_files
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) all WHAT="cmd/kubeadm" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define HOST_KUBERNETES_KUBEADM_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubeadm $(HOST_DIR)/usr/bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
