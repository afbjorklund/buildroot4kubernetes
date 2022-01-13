################################################################################
#
# cri-dockerd
#
################################################################################

CRI_DOCKERD_VERSION = 0.2.0
CRI_DOCKERD_SITE = $(call github,Mirantis,cri-dockerd,v$(CRI_DOCKERD_VERSION))
CRI_DOCKERD_LICENSE = Apache-2.0
CRI_DOCKERD_LICENSE_FILES = LICENSE

CRI_DOCKERD_DEPENDENCIES = host-go

CRI_DOCKERD_GOPATH = $(@D)/_output
CRI_DOCKERD_ENV = \
	$(GO_TARGET_ENV) \
	CGO_ENABLED=0 \
	GO111MODULE=on \
	GOPATH="$(CRI_DOCKERD_GOPATH)" \
	GOBIN="$(CRI_DOCKERD_GOPATH)/bin" \
	PATH=$(CRI_DOCKERD_GOPATH)/bin:$(BR_PATH)

define CRI_DOCKERD_BUILD_CMDS
	$(CRI_DOCKERD_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) static-linux
endef

define CRI_DOCKERD_INSTALL_TARGET_CMDS
	$(INSTALL) -Dm755 \
		$(@D)/packaging/static/build/linux/cri-dockerd/cri-dockerd \
		$(TARGET_DIR)/usr/bin/cri-dockerd
endef

define CRI_DOCKERD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -Dm644 \
		$(@D)/packaging/systemd/cri-docker.service \
		$(TARGET_DIR)/usr/lib/systemd/system/cri-docker.service
	$(INSTALL) -Dm644 \
		$(@D)/packaging/systemd/cri-docker.socket \
		$(TARGET_DIR)/usr/lib/systemd/system/cri-docker.socket
endef

$(eval $(generic-package))
