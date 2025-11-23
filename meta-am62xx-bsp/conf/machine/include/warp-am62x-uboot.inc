# U-Boot configuration for WARP-AM62X machine

# Set the default device tree file for U-Boot
UBOOT_DTB = "warp-am62x.dtb"

# Set the TI FDT folder path for device tree location
UBOOT_TI_FDT_FOLDER_PATH = "warp-am62x"

# Configure U-Boot to use the correct device tree
UBOOT_CONFIG_FRAGMENTS:append = " warp-am62x.cfg"

# Set the board name for U-Boot
UBOOT_BOARD_NAME = "warp-am62x"

# Additional U-Boot environment variables
UBOOT_ENVIRONMENT = " \
    warp-am62x.env \
"

# U-Boot boot command configuration
UBOOT_BOOTCOMMAND = "run findfdt; run init_kernel; run run_kernel;"

# Set the default device tree in U-Boot config
UBOOT_EXTRACONFIG = " \
    CONFIG_DEFAULT_FDT_FILE=\"warp-am62x.dtb\" \
    CONFIG_TI_FDT_FOLDER_PATH=\"warp-am62x\" \
"