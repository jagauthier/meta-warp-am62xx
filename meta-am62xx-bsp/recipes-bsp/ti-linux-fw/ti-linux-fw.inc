SUMMARY = "Common include for TI Linux firmware"

LICENSE = "TI-TFL"
LIC_FILES_CHKSUM = "file://LICENSE.ti;md5=b5aebf0668bdf95621259288c4a46d76"

# PV = "2022.01"
PV = "1.0+git${SRCPV}"
INC_PR = "r4"

# Firmware versions
CORESDK_RTOS_VERSION = "08.02.00.04"
PRUETH_FW_AM65X_VERSION = "08.00.00.20"
PRUETH_FW_AM65X_SR2_VERSION = "02.02.11.02"
GOODIX_FW_VERSION = "1.0.0.0"
CADENCE_MHDP_FW_VERSION = "2.1.0"
IMG_DEC_FW_VERSION = "1.0"
CNM_WAVE521_FW_VERSION = "1.0.00"
TI_DM_FW_VERSION = "10.01.01"
TI_SYSFW_VERSION = "10.01.01"

TI_LINUX_FW_SRCREV ?= "905eb58564581d951d148f45828e8c8a142a5938"
# SRCREV = "${TI_LINUX_FW_SRCREV}"
SRCREV = "${AUTOREV}"

BRANCH ?= "ti-linux-firmware"

SRC_URI = "git://git.ti.com/git/processor-firmware/ti-linux-firmware.git;protocol=https;branch=${BRANCH}"

S = "${WORKDIR}/git"
