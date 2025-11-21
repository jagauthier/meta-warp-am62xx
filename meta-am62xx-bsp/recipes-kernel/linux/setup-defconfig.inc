# KERNEL_LOCALVERSION can be set to add a tag to the end of the
# kernel version string.  such as the commit id
KERNEL_LOCALVERSION = ""

# Check the defconfig file and see if it points to an in kernel
# defconfig that should be used, or if it is a complete config file
# Or if it points to a combined defconfig that lists both in kernel
# defconfig and associated config fragments.

KERNEL_CONFIG_FRAGMENTS="${S}/kernel/configs/ti_arm64_prune.config"
OTHER_CONFIG_FRAMENTS=" ${RT_CONFIG_FRAGMENT} ${S}/kernel/configs/am625x_custom.config"

# These items must match the machine name!

do_configure() {
	
	# copy over the custom files
	cp ${UNPACKDIR}/configs/* ${S}/kernel/configs
	cp -r ${UNPACKDIR}/dts/${MACHINE} ${S}/arch/arm64/boot/dts
	echo 'subdir-y += ${MACHINE}' >> ${S}/arch/arm64/boot/dts/Makefile
	
	# I don't want to kernel to show up as 'dirty'. That's dumb.
	rm -rf ${B}/.git 
	rm -rf ${S}/.git 
		
	# Create the default config
	cat ${KERNEL_CONFIG_FRAGMENTS} ${OTHER_CONFIG_FRAMENTS} > ${S}/kernel/configs/my.config
	
    echo ${KERNEL_LOCALVERSION} > ${B}/.scmversion
    echo ${KERNEL_LOCALVERSION} > ${S}/.scmversion

	oe_runmake -C ${S} O=${B} defconfig my.config
}
