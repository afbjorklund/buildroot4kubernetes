################################################################################
#
# cri-tools
#
################################################################################

CRI_TOOLS_VERSION = 1.24.0
CRI_TOOLS_SITE = $(call github,kubernetes-sigs,cri-tools,v$(CRI_TOOLS_VERSION))
CRI_TOOLS_LICENSE = Apache-2.0
CRI_TOOLS_LICENSE_FILES = LICENSE

CRI_TOOLS_GOMOD = github.com/kubernetes-sigs/cri-tools

CRI_TOOLS_LDFLAGS = \
	-X $(CRI_TOOLS_GOMOD)/pkg/version.Version=$(CRI_TOOLS_VERSION)

ifeq ($(BR2_PACKAGE_CRI_TOOLS_CRICTL),y)
	CRI_TOOLS_BUILD_TARGETS += cmd/crictl
endif
ifeq ($(BR2_PACKAGE_CRI_TOOLS_CRITEST),y)
	CRI_TOOLS_BUILD_TARGETS += cmd/critest
endif

CRI_TOOLS_INSTALL_BINS = $(notdir $(CRI_TOOLS_BUILD_TARGETS))

$(eval $(golang-package))
