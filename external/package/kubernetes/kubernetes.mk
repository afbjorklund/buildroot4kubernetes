################################################################################
#
# kubernetes
#
################################################################################

KUBERNETES_VERSION = 1.20.5
KUBERNETES_SITE = https://github.com/kubernetes/kubernetes/archive
KUBERNETES_LICENSE = Apache-2.0

KUBERNETES_SOURCE = v$(KUBERNETES_VERSION).tar.gz

$(eval $(generic-package))
