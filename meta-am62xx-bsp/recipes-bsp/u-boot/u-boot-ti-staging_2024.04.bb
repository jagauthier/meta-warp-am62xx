require u-boot-ti.inc

# There are two entries per "machine" because the build is multiconfig.
include ${@ 'recipes-bsp/u-boot/myir-6252-am62x-uboot.inc' if d.getVar('MACHINE') == 'myir-6252-am62x' else ''}
include ${@ 'recipes-bsp/u-boot/myir-6252-am62x-uboot.inc' if d.getVar('MACHINE') == 'myir-6252-am62x-k3r5' else ''}

include ${@ 'recipes-bsp/u-boot/ti-extras.inc' if d.getVar('TI_EXTRAS') else ''}
include ${@ 'recipes-bsp/u-boot/myir-6254-am62x-uboot.inc' if d.getVar('MACHINE') == 'myir-6254-am62x' else ''}
include ${@ 'recipes-bsp/u-boot/myir-6254-am62x-uboot.inc' if d.getVar('MACHINE') == 'myir-6254-am62x-k3r5' else ''}

include ${@ 'recipes-bsp/u-boot/warp-am62x-uboot.inc' if d.getVar('MACHINE') == 'warp-am62x' else ''}
include ${@ 'recipes-bsp/u-boot/warp-am62x-uboot.inc' if d.getVar('MACHINE') == 'warp-am62x-k3r5' else ''}


CLEANBEFOREBUILD = "1"

BRANCH = "ti-u-boot-2024.04"
UBOOT_GIT_URI = "git://git.ti.com/git/processor-sdk/u-boot.git"

PR = "r0"

VER="2024.04"
SRCREV = "${AUTOREV}"

