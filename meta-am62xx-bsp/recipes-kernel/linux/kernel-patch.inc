# kind of a hack to apply the RT kernel patches
do_patch() {
	  patch -d ${S}-p1 < ${UNPACKDIR}/patches/${KERNEL_PATCHES} 
}