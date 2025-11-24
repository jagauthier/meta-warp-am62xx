SUMMARY = "Common include for TI Linux firmware"

LICENSE = "TI-TFL"
LIC_FILES_CHKSUM = "file://LICENSE.ti;md5=b5aebf0668bdf95621259288c4a46d76"

PV = "2022.01"
INC_PR = "r4"

# Firmware versions
TI_DM_FW_VERSION = "11.2.5"
TI_SYSFW_VERSION = "11.2.5"

# Version 11
TI_LINUX_FW_SRCREV ?= "b45ffc03a1fb1e039dbe54871eeaa7b430bae1a0"

# Version 10
#TI_LINUX_FW_SRCREV ?= "6a644ed88a33c97da18828cded4fd36bb0be631f"
# Version 9
#TI_LINUX_FW_SRCREV ?= "3987d170fc522565c5e4a9293aba1db75951b8c0"
# Version 8
#TI_LINUX_FW_SRCREV ?= "2944354aca1f95525c30d625cb17672930e72572"
SRCREV = "${TI_LINUX_FW_SRCREV}"


BRANCH ?= "ti-linux-firmware"

SRC_URI = "git://git.ti.com/git/processor-firmware/ti-linux-firmware.git;protocol=https;branch=${BRANCH}"

S = "${WORKDIR}/git"

CLEANBROKEN = "1"

# Make sure that lib/firmware, and all its contents are part of the package
FILES:${PN} = "${nonarch_base_libdir}/firmware"

# This is used to prevent the build system from stripping the firmwares
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_SYSROOT_STRIP = "1"

# This is used to prevent the build system from splitting out the firmware debug info into a separate file
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

# Disable arch checking as firmware is likely to be a different arch from the Yocto build
INSANE_SKIP:${PN} += "arch"

# Firmware in Linux Firmware has no configure nor build steps
do_compile[noexec] = "1"
do_configure[noexec] = "1"
