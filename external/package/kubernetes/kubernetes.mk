################################################################################
#
# kubernetes
#
################################################################################

KUBERNETES_VERSION = 1.28.8
KUBERNETES_SITE = $(call github,kubernetes,kubernetes,v$(KUBERNETES_VERSION))
KUBERNETES_LICENSE = Apache-2.0
KUBERNETES_LICENSE_FILES = LICENSE

$(eval $(generic-package))
