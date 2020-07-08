################################################################################
#
# cni-plugins
#
################################################################################

CNI_PLUGINS_VERSION = 0.8.6
CNI_PLUGINS_SITE = https://github.com/containernetworking/plugins/archive
CNI_PLUGINS_LICENSE = Apache-2.0

CNI_PLUGINS_SOURCE = v$(CNI_PLUGINS_VERSION).tar.gz

CNI_PLUGINS_MAKE_ENV = \
	$(HOST_GO_CROSS_ENV) \
	CGO_ENABLED=0 \
	GO111MODULE=on

CNI_PLUGINS_BUILDFLAGS = -ldflags '-extldflags -static -X github.com/containernetworking/plugins/pkg/utils/buildversion.BuildVersion=v$(CNI_PLUGINS_VERSION)'

define CNI_PLUGINS_BUILD_CMDS
	(cd $(@D); $(CNI_PLUGINS_MAKE_ENV) ./build_linux.sh $(CNI_PLUGINS_BUILDFLAGS))
endef

define CNI_PLUGINS_INSTALL_TARGET_CMDS
	cd $(@D); for bin in bin/*; do \
		$(INSTALL) -D -m 0755 \
			$(@D)/$$bin \
			$(TARGET_DIR)/opt/cni/$$bin; \
		ln -sf \
			../../opt/cni/$$bin \
			$(TARGET_DIR)/usr/$$bin; \
	done
endef

$(eval $(generic-package))
