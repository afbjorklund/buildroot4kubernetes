################################################################################
#
# cri-tools
#
################################################################################

CRI_TOOLS_VERSION = 1.19.0
CRI_TOOLS_SITE = https://github.com/kubernetes-sigs/cri-tools/archive
CRI_TOOLS_LICENSE = Apache-2.0

CRI_TOOLS_SOURCE = v$(CRI_TOOLS_VERSION).tar.gz

CRI_TOOLS_MAKE_ENV = \
	$(GO_TARGET_ENV) \
	GO111MODULE=on

ifeq ($(BR2_PACKAGE_CRI_TOOLS_CRICTL),y)
	CRI_TOOLS_PROGRAMS += crictl
endif
ifeq ($(BR2_PACKAGE_CRI_TOOLS_CRITEST),y)
	CRI_TOOLS_PROGRAMS += critest
endif

define CRI_TOOLS_BUILD_CMDS
	$(CRI_TOOLS_MAKE_ENV) $(MAKE) -C $(@D) VERSION=v$(CRI_TOOLS_VERSION) $(CRI_TOOLS_PROGRAMS)
endef
define CRI_TOOLS_INSTALL_TARGET_CMDS
	for program in $(CRI_TOOLS_PROGRAMS); do \
		$(INSTALL) -D -m 0755 $(@D)/_output/$$program $(TARGET_DIR)/usr/bin; \
	done
endef

$(eval $(generic-package))
