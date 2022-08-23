################################################################################
#
# cri-dockerd
#
################################################################################

CRI_DOCKERD_VERSION = 0.2.5
CRI_DOCKERD_SITE = $(call github,Mirantis,cri-dockerd,v$(CRI_DOCKERD_VERSION))
CRI_DOCKERD_LICENSE = Apache-2.0
CRI_DOCKERD_LICENSE_FILES = LICENSE

CRI_DOCKERD_GOMOD = github.com/Mirantis/cri-dockerd

CRI_DOCKERD_LDFLAGS = \
	-X $(CRI_DOCKERD_GOMOD)/cmd/version.BuildTime="" \
	-X $(CRI_DOCKERD_GOMOD)/cmd/version.GitCommit="buildroot" \
	-X $(CRI_DOCKERD_GOMOD)/cmd/version.Version=$(CRI_DOCKERD_VERSION)

CRI_DOCKERD_BUILD_TARGETS = .

CRI_DOCKERD_INSTALL_BINS = cri-dockerd

define CRI_DOCKERD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -Dm644 \
		$(@D)/packaging/systemd/cri-docker.service \
		$(TARGET_DIR)/usr/lib/systemd/system/cri-docker.service
	$(INSTALL) -Dm644 \
		$(@D)/packaging/systemd/cri-docker.socket \
		$(TARGET_DIR)/usr/lib/systemd/system/cri-docker.socket
endef

$(eval $(golang-package))
