################################################################################
#
# nomad-containerd
#
################################################################################

NOMAD_CONTAINERD_VERSION = 0.5
NOMAD_CONTAINERD_SITE = https://github.com/Roblox/nomad-driver-containerd/archive
NOMAD_CONTAINERD_LICENSE = APL-2.0
NOMAD_CONTAINERD_LICENSE_FILES = LICENSE

NOMAD_CONTAINERD_SOURCE = v$(NOMAD_CONTAINERD_VERSION).tar.gz

NOMAD_CONTAINERD_GO_ENV += GO111MODULE=on

define NOMAD_CONTAINERD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/nomad-containerd \
	                      $(TARGET_DIR)/usr/bin/nomad-driver-containerd
endef

$(eval $(golang-package))
