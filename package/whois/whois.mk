################################################################################
#
# whois
#
################################################################################

WHOIS_VERSION = 5.1.3
WHOIS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/w/whois
WHOIS_SOURCE = whois_$(WHOIS_VERSION).tar.xz
# take precedence over busybox implementation
WHOIS_DEPENDENCIES = host-gettext $(if $(BR2_PACKAGE_BUSYBOX),busybox)
WHOIS_MAKE_ENV = $(TARGET_MAKE_ENV)
WHOIS_MAKE_OPT = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)"
WHOIS_LICENSE = GPLv2+
WHOIS_LICENSE_FILES = COPYING

ifeq ($(BR2_NEEDS_GETTEXT),y)
WHOIS_DEPENDENCIES += gettext
WHOIS_MAKE_OPT += LIBS="-lintl"
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
WHOIS_DEPENDENCIES += libiconv
WHOIS_MAKE_ENV += HAVE_ICONV=1
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
WHOIS_DEPENDENCIES += libidn
WHOIS_MAKE_ENV += HAVE_LIBIDN=1
endif

define WHOIS_BUILD_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPT) -C $(@D)
endef

define WHOIS_INSTALL_TARGET_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPT) \
		BASEDIR="$(TARGET_DIR)" install -C $(@D)
endef

$(eval $(generic-package))