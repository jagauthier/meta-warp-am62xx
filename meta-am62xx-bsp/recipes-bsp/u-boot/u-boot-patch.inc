SRC_URI += "file://patches/u-boot.patch"

# Apply some patches to u-boot
do_patch() {

	 patch -d ${S} -p1 < ${UNPACKDIR}/patches/u-boot.patch

}