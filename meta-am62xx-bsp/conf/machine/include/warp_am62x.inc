require conf/machine/include/k3.inc
SOC_FAMILY:append = ":am62xx"

MACHINE_FEATURES += "screen"

# Default tiboot3.bin on AM62x is for HS-FS
# IMAGE_BOOT_FILES += "tiboot3-am62x-hs-fs-evm.bin"

# Since default tiboot3.bin on AM62x is for HS-FS, add a version for GP
#IMAGE_BOOT_FILES += "tiboot3-am62x-gp-evm.bin"

# Since default tiboot3.bin on AM62x is for HS-FS, add a version for HS-SE
#IMAGE_BOOT_FILES += "tiboot3-am62x-hs-evm.bin"


TFA_BOARD = "lite"
TFA_K3_SYSTEM_SUSPEND = "1"

OPTEEMACHINE = "k3-am62x"

# Normally AM62 boards use ttyS2, but our Jailhouse inmate may use ttyS3, so try both
SERIAL_CONSOLES = "115200;ttyS2"
