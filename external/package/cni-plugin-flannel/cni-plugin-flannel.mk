################################################################################
#
# cni-plugin-flannel
#
################################################################################

CNI_PLUGIN_FLANNEL_VERSION = 1.1.0
CNI_PLUGIN_FLANNEL_SITE = $(call github,flannel-io,cni-plugin,v$(CNI_PLUGIN_FLANNEL_VERSION))
CNI_PLUGIN_FLANNEL_LICENSE = Apache-2.0
CNI_PLUGIN_FLANNEL_LICENSE_FILES = LICENSE

CNI_PLUGIN_FLANNEL_LDFLAGS = \
	-X main.Program=flannel \
	-X main.Version=$(CNI_PLUGIN_FLANNEL_VERSION)

CNI_PLUGIN_FLANNEL_BIN_NAME = flannel

CNI_PLUGIN_FLANNEL_INSTALL_BINS = flannel

define CNI_PLUGIN_FLANNEL_INSTALL_TARGET_CMDS
	$(foreach d,$(CNI_PLUGIN_FLANNEL_INSTALL_BINS),\
		$(INSTALL) -D -m 0755 \
			$(@D)/bin/$(d) \
			$(TARGET_DIR)/opt/cni/bin/$(d); \
		ln -sf \
			../../opt/cni/bin/$(d) \
			$(TARGET_DIR)/usr/bin/$(d); \
	)
endef

$(eval $(golang-package))
