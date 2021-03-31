################################################################################
#
# kubernetes kubelet
#
################################################################################

KUBERNETES_KUBELET_VERSION = 1.20.5
KUBERNETES_KUBELET_SITE = $(KUBERNETES_SITE)
KUBERNETES_KUBELET_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
KUBERNETES_KUBELET_LICENSE = Apache-2.0

KUBERNETES_KUBELET_SOURCE = $(KUBERNETES_SOURCE)

# See https://github.com/kubernetes/release
KUBERNETES_KUBEPKG_RELEASE_VERSION = v0.7.0

define KUBERNETES_KUBELET_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) generated_files
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all WHAT="cmd/kubelet" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define KUBERNETES_KUBELET_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubelet $(TARGET_DIR)/usr/bin
endef

define KUBERNETES_KUBELET_INSTALL_INIT_SYSTEMD
	# "https://raw.githubusercontent.com/kubernetes/release/$(KUBERNETES_KUBEPKG_RELEASE_VERSION)/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service"
	$(INSTALL) -D -m 0644 $(KUBERNETES_KUBELET_PKGDIR)/kubelet.service \
		$(TARGET_DIR)/usr/lib/systemd/system/kubelet.service

	# "https://raw.githubusercontent.com/kubernetes/release/$(KUBERNETES_KUBEPKG_RELEASE_VERSION)/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf"
	$(INSTALL) -D -m 0644 $(KUBERNETES_KUBELET_PKGDIR)/10-kubeadm.conf \
		$(TARGET_DIR)/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
endef

$(eval $(generic-package))
