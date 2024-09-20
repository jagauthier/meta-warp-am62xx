SUMMARY = "for sdcard program"
DESCRIPTION = "use sdcard boot up and program full image to emmc"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://licenses/GPL-2;md5=94d55d512a9ba36caa9b7df079bae19f"

inherit  systemd

S = "${WORKDIR}"

SRC_URI = "file://home/root/burn_emmc.sh \
           file://licenses/GPL-2 \
          "

do_install(){

	install -d ${D}/home/root/

	install -m 755 ${WORKDIR}/home/root/burn_emmc.sh ${D}/home/root/burn_emmc.sh
	

}

FILES:${PN} = "/"

