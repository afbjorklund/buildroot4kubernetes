################################################################################
#
# nomad
#
################################################################################

NOMAD_VERSION = 0.11.8
NOMAD_SITE = $(call github,hashicorp,nomad,v$(NOMAD_VERSION))
NOMAD_LICENSE = MPL-2.0
NOMAD_LICENSE_FILES = LICENSE

NOMAD_WORKSPACE = vendor

NOMAD_LDFLAGS = \
	-X github.com/hashicorp/nomad/version.GitCommit=$(NOMAD_VERSION)

NOMAD_TAGS = codegen_generated

NOMAD_INSTALL_BINS = nomad

$(eval $(golang-package))
