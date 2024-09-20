DESCRIPTION = "Task to install wireless packages into the target FS"
LICENSE = "MIT"
PR = "r42"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

# WLAN support packages.
# These are the packages that all platforms use for WLAN support
# add wireless-regdb-static
WLAN_COMMON = "\
    iw \
    softap-udhcpd-config \
    eventdump \
    wlconf \
    wireless-regdb-static \
"

WLAN_TI = "\
    wpa-supplicant \
    hostapd \
"

BT_COMMON = "\
    bluez5 \
    bluez5-obex \
    bluez5-noinst-tools \
    bluez5-testtools \
    pulseaudio \
    pulseaudio-server \
    pulseaudio-module-loopback \
    pulseaudio-module-bluetooth-discover \
    pulseaudio-module-bluetooth-policy \
    pulseaudio-module-bluez5-device \
    pulseaudio-module-bluez5-discover \
    pulseaudio-lib-bluez5-util \
    sbc \
    linux-firmware-ibt-18 \
"

BT_TI = "\
    bt-enable \
    bt-fw \
"

CONNECTIVITY_RDEPENDS = " \
    htop \
    iptables \
    iproute2 \
    iproute2-tc \
    iproute2-devlink \
    ${WLAN_COMMON} \
    ${WLAN_TI} \
    ${BT_COMMON} \
    ${BT_TI} \
"

RDEPENDS:${PN} = "\
    ${CONNECTIVITY_RDEPENDS} \
"
