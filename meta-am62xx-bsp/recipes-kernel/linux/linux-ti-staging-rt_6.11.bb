require linux-ti-staging_6.11.bb

# Look in the generic major.minor directory for files
# This will have priority over generic non-rt path
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.11:"

RT_CONFIG_FRAGMENT="${S}/kernel/configs/ti_rt.config"

KERNEL_PATCHES="patch-6.11-rt7.patch"

SRC_URI += "file://patches/patch-6.11-rt7.patch"