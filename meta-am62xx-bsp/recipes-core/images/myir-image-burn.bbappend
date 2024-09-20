ROOTFS_POSTPROCESS_COMMAND:append:am62xx = "install_upgrade_info; "



install_upgrade_info() {



		if [ -f ${IMAGE_ROOTFS}${systemd_system_unitdir}/check_upgrade.service ];then
			echo " " > ${IMAGE_ROOTFS}${systemd_system_unitdir}/check_upgrade.service
		fi

		if [ -f ${IMAGE_ROOTFS}/etc/udev/scripts/mount.sh ];then
			echo " " > ${IMAGE_ROOTFS}/etc/udev/scripts/mount.sh
		fi


}
