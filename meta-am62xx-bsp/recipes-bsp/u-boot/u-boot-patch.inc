SRC_URI += "file://patches/u-boot.patch"

do_configure_WHATEVER() {

	# we're making changes and we don't want it to be "dirty"
	rm -rf ${S}/.git
	rm -rf ${B}/.git

}

# Apply some patches to u-boot
do_patch() {

	 patch -d ${S} -p1 < ${WORKDIR}/patches/u-boot.patch
	 
	  
}
