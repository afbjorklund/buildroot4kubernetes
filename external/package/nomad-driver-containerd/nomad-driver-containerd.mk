################################################################################
#
# nomad-driver-containerd
#
################################################################################

NOMAD_DRIVER_CONTAINERD_VERSION = 0.5
NOMAD_DRIVER_CONTAINERD_SITE = https://github.com/Roblox/nomad-driver-containerd/archive
NOMAD_DRIVER_CONTAINERD_LICENSE = APL-2.0
NOMAD_DRIVER_CONTAINERD_LICENSE_FILES = LICENSE

NOMAD_DRIVER_CONTAINERD_SOURCE = v$(NOMAD_DRIVER_CONTAINERD_VERSION).tar.gz

NOMAD_DRIVER_CONTAINERD_GO_ENV += GO111MODULE=on

NOMAD_DRIVER_CONTAINERD_INSTALL_BINS = bin/nomad-driver-containerd

$(eval $(golang-package))
