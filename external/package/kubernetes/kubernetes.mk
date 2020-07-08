################################################################################
#
# kubernetes
#
################################################################################

KUBERNETES_VERSION = 1.18.5
KUBERNETES_SITE = https://github.com/kubernetes/kubernetes/archive
KUBERNETES_LICENSE = Apache-2.0

KUBERNETES_SOURCE = v$(KUBERNETES_VERSION).tar.gz

# See https://github.com/kubernetes/release
KUBERNETES_KUBEPKG_RELEASE_VERSION = v0.3.2

define KUBERNETES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) generated_files
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all WHAT="cmd/kubeadm cmd/kubelet cmd/kubectl" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define KUBERNETES_INSTALL_TARGET_CMDS
$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubeadm $(TARGET_DIR)/usr/bin
$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubelet $(TARGET_DIR)/usr/bin
$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubectl $(TARGET_DIR)/usr/bin
endef

define KUBERNETES_INSTALL_INIT_SYSTEMD
	# "https://raw.githubusercontent.com/kubernetes/release/$(KUBERNETES_KUBEPKG_RELEASE_VERSION)/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service"
	$(INSTALL) -D -m 0644 $(KUBERNETES_PKGDIR)/kubelet.service \
		$(TARGET_DIR)/usr/lib/systemd/system/kubelet.service

	# "https://raw.githubusercontent.com/kubernetes/release/$(KUBERNETES_KUBEPKG_RELEASE_VERSION)/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf"
	$(INSTALL) -D -m 0644 $(KUBERNETES_PKGDIR)/kubelet.service.d/10-kubeadm.conf \
		$(TARGET_DIR)/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
endef

$(eval $(generic-package))
