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
    myir-test-extras \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-graphics','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-gtk','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-qte','',d)} \
    ${@['','packagegroup-myir-tisdk-opencl'][oe.utils.all_distro_features(d, 'opencl', True, False) and bb.utils.contains('MACHINE_FEATURES', 'dsp', True, False, d)]} \
    packagegroup-myir-tisdk-connectivity \
    packagegroup-myir-tisdk-crypto \
    packagegroup-myir-tisdk-multimedia \
    packagegroup-myir-tisdk-addons \
    packagegroup-myir-tisdk-addons-extra \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl','packagegroup-myir-tisdk-hmi','packagegroup-myir-base-tisdk-server-extra',d)} \
    ${ARAGO_DEFAULT_IMAGE_EXTRA_INSTALL} \
    packagegroup-myir-tisdk-sysrepo \
    proftpd \
"

export IMAGE_BASENAME = "myir-image-full"

# Disable ubi/ubifs as the filesystem requires more space than is
# available on the HW.
IMAGE_FSTYPES:remove:omapl138 = "ubifs ubi"

# Below is the delta in packages between old fuller and a new smaller default rootfs
CHROMIUM = ""
CHROMIUM:append:omap-a15 = "\
    chromium-ozone-wayland \
"
CHROMIUM:append:k3 = "\
    chromium-ozone-wayland \
"

EXTRABROWSERS = " \
    qtwebbrowser-examples \
    qtwebengine-qmlplugins \
    qtwebengine-examples \
"

PYTHON2APPS = " \
    ${@bb.utils.contains('DISTRO_FEATURES','opengl',"${EXTRABROWSERS}",'',d)} \
    ${@bb.utils.contains("BBFILE_COLLECTIONS","browser-layer",bb.utils.contains('DISTRO_FEATURES','wayland',"${CHROMIUM}",'',d),'',d)} \
"



DEVTOOLS = " \
    linux-libc-headers-dev \
    build-essential \
    packagegroup-core-tools-debug \
    git \
"

OPENCL = " \
    ${@bb.utils.contains('MACHINE_FEATURES','dsp','ti-opencl','',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES','dsp','packagegroup-myir-tisdk-opencl-extra','',d)} \
"

IMAGE_INSTALL += "\
    ${@oe.utils.all_distro_features(d, "opencl", "${OPENCL}")} \
    ${@bb.utils.contains("BBFILE_COLLECTIONS", "meta-python2", "${PYTHON2APPS}", "", d)} \
    ${@bb.utils.contains('TUNE_FEATURES', 'armv7a', 'valgrind', '', d)} \
    auto-wifi \
    fgl297-fw \
    wifi-load \
   	nxp-wlan-sdk \
    ppp-quectel \
    ppp \
    quectel-cm \
    hmi \
    libmodbus \
    wireless-tools \
    coreutils \
    util-linux \
    tslib \
    fbv \
    hwmac \
"
