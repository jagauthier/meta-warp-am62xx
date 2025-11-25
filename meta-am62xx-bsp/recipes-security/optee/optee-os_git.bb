require recipes-security/optee/optee-os.inc

DEPENDS += "dtc-native"

# Override the SRC_URI from meta-arm to exclude all patches
SRC_URI = "git://github.com/OP-TEE/optee_os.git;branch=master;protocol=https"

# Set the version from the version file
require ${BPN}-ti-version.inc

# Include TI-specific overrides
require ${BPN}-ti-overrides.inc