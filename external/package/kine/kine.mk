################################################################################
#
# kine
#
################################################################################

KINE_VERSION = 0.9.4
KINE_SITE = $(call github,k3s-io,kine,v$(KINE_VERSION))
KINE_LICENSE = Apache-2.0
KINE_LICENSE_FILES = LICENSE

KINE_GO_ENV = \
	CGO_CFLAGS="$(TARGET_CFLAGS) -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_USE_ALLOCA=1"

KINE_GOMOD = github.com/k3s-io/kine

KINE_LDFLAGS = \
	-X $(KINE_GOMOD)/pkg/version.Version=$(KINE_VERSION) \
	-X $(KINE_GOMOD)/pkg/version.GitCommit="buildroot"

$(eval $(golang-package))
