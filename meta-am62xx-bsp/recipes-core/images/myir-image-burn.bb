SUMMARY = "Arago TI SDK full filesystem image"

DESCRIPTION = "Complete Arago TI SDK filesystem image containing complete\
 applications and packages to entitle the SoC."

require myir-base-image.inc

ARAGO_DEFAULT_IMAGE_EXTRA_INSTALL ?= ""

# we're assuming some display manager is being installed with opengl
SYSTEMD_DEFAULT_TARGET = " \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl','graphical.target','multi-user.target',d)} \
"

IMAGE_INSTALL += "\
    packagegroup-myir-base \
    packagegroup-myir-console \
    packagegroup-myir-base-tisdk \
    myir-test \
"

export IMAGE_BASENAME = "myir-image-burn"

# Disable ubi/ubifs as the filesystem requires more space than is
# available on the HW.
IMAGE_FSTYPES:remove:omapl138 = "ubifs ubi"



IMAGE_INSTALL += "\
    fac-burn-emmc-full \
    mmc-utils \
"
