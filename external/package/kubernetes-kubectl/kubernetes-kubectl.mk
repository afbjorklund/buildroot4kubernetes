################################################################################
#
# kubernetes kubectl
#
################################################################################

KUBERNETES_KUBECTL_VERSION = 1.23.0
KUBERNETES_KUBECTL_SITE = $(KUBERNETES_SITE)
KUBERNETES_KUBECTL_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
HOST_KUBERNETES_KUBECTL_DL_SUBDIR = $(KUBERNETES_DL_SUBDIR)
KUBERNETES_KUBECTL_LICENSE = Apache-2.0
KUBERNETES_KUBECTL_LICENSE_FILES = LICENSE

KUBERNETES_KUBECTL_SOURCE = $(KUBERNETES_SOURCE)

define KUBERNETES_KUBECTL_BUILD_CMDS
	echo $(KUBERNETES_KUBECTL_BASENAME)
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) generated_files
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) all WHAT="cmd/kubectl" KUBE_BUILD_PLATFORMS="linux/$(GO_GOARCH)"
endef

define KUBERNETES_KUBECTL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/linux/$(GO_GOARCH)/kubectl $(TARGET_DIR)/usr/bin
endef

define HOST_KUBERNETES_KUBECTL_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) generated_files
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D) all WHAT="cmd/kubectl" KUBE_BUILD_PLATFORMS="$$(go env GOOS)/$(GO_GOARCH)" KUBE_CGO_OVERRIDES=kubectl
endef

define HOST_KUBERNETES_KUBECTL_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/_output/local/bin/$$(go env GOOS)/$(GO_GOARCH)/kubectl $(HOST_DIR)/bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
