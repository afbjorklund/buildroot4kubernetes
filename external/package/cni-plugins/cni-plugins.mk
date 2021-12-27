################################################################################
#
# cni-plugins
#
################################################################################

CNI_PLUGINS_VERSION = 0.8.7
CNI_PLUGINS_SITE = $(call github,containernetworking,plugins,v$(CNI_PLUGINS_VERSION))
CNI_PLUGINS_LICENSE = Apache-2.0
CNI_PLUGINS_LICENSE_FILES = LICENSE

CNI_PLUGINS_MAKE_ENV = \
	$(GO_TARGET_ENV) \
	GO111MODULE=on

CNI_PLUGINS_BUILDFLAGS = -ldflags '-extldflags -static -X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=v$(CNI_PLUGINS_VERSION)'

ifeq ($(BR2_PACKAGE_CNI_PLUGINS_BASIC),y)
	CNI_PLUGINS_PROGRAMS += bridge loopback ptp
	CNI_PLUGINS_PROGRAMS += host-local
	CNI_PLUGINS_PROGRAMS += portmap sbr
	CNI_PLUGINS_PROGRAMS += firewall tuning
	CNI_PLUGINS_PROGRAMS += flannel
endif
ifeq ($(BR2_PACKAGE_CNI_PLUGINS_EXTRA),y)
	CNI_PLUGINS_PROGRAMS += ipvlan macvlan
	CNI_PLUGINS_PROGRAMS += vlan host-device
	CNI_PLUGINS_PROGRAMS += dhcp static
	CNI_PLUGINS_PROGRAMS += bandwidth
endif

define CNI_PLUGINS_BUILD_CMDS
	(cd $(@D); $(CNI_PLUGINS_MAKE_ENV) ./build_linux.sh $(CNI_PLUGINS_BUILDFLAGS))
endef

define CNI_PLUGINS_INSTALL_TARGET_CMDS
	cd $(@D); for program in $(CNI_PLUGINS_PROGRAMS); do \
		bin=bin/$$program; \
		$(INSTALL) -D -m 0755 \
			$(@D)/$$bin \
			$(TARGET_DIR)/opt/cni/$$bin; \
		ln -sf \
			../../opt/cni/$$bin \
			$(TARGET_DIR)/usr/$$bin; \
	done
endef

$(eval $(generic-package))
