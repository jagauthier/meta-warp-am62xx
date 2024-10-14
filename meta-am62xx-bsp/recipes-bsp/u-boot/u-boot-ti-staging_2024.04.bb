require u-boot-ti.inc
require u-boot-patch.inc

include ${@ 'recipes-bsp/u-boot/ti-extras.inc' if d.getVar('TI_EXTRAS') else ''}

PR = "r0"

BRANCH = "ti-u-boot-2024.04"

VER="2024.04"

SRCREV = "${AUTOREV}"
