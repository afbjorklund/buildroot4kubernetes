################################################################################
#
# cni-plugins
#
################################################################################

CNI_PLUGINS_VERSION = 1.1.1
CNI_PLUGINS_SITE = $(call github,containernetworking,plugins,v$(CNI_PLUGINS_VERSION))
CNI_PLUGINS_LICENSE = Apache-2.0
CNI_PLUGINS_LICENSE_FILES = LICENSE

CNI_PLUGINS_GOMOD = github.com/containernetworking/plugins

CNI_PLUGINS_LDFLAGS = \
	-X $(CNI_PLUGINS_GOMOD)/pkg/utils/buildversion.BuildVersion=v$(CNI_PLUGINS_VERSION)

ifeq ($(BR2_PACKAGE_CNI_PLUGINS_BASIC),y)
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/bridge
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/loopback
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/ptp
	CNI_PLUGINS_BUILD_TARGETS += plugins/ipam/host-local
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/portmap
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/sbr
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/firewall
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/tuning
endif
ifeq ($(BR2_PACKAGE_CNI_PLUGINS_EXTRA),y)
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/ipvlan
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/macvlan
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/vlan
	CNI_PLUGINS_BUILD_TARGETS += plugins/main/host-device
	CNI_PLUGINS_BUILD_TARGETS += plugins/ipam/dhcp
	CNI_PLUGINS_BUILD_TARGETS += plugins/ipam/static
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/bandwidth
	CNI_PLUGINS_BUILD_TARGETS += plugins/meta/vrf
endif

CNI_PLUGINS_INSTALL_BINS = $(notdir $(CNI_PLUGINS_BUILD_TARGETS))

define CNI_PLUGINS_INSTALL_TARGET_CMDS
	$(foreach d,$(CNI_PLUGINS_INSTALL_BINS),\
		$(INSTALL) -D -m 0755 \
			$(@D)/bin/$(d) \
			$(TARGET_DIR)/opt/cni/bin/$(d); \
		ln -sf \
			../../opt/cni/bin/$(d) \
			$(TARGET_DIR)/usr/bin/$(d); \
	)
endef

$(eval $(golang-package))
