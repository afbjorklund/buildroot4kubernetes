################################################################################
#
# kubernetes
#
################################################################################

KUBERNETES_VERSION = 1.21.0
KUBERNETES_SITE = $(call github,kubernetes,kubernetes,v$(KUBERNETES_VERSION))
KUBERNETES_LICENSE = Apache-2.0

$(eval $(generic-package))
