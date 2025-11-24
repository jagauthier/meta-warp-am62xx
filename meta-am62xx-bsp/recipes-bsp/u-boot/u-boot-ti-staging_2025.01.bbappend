UBOOT_PATCHES_myir-6252-am62x = "0001-binman-symlink-change-${VER}.patch \
                                 0002-mmc-gpio-low-${VER}.patch  \
                                 0003-configure-boot-env-${VER}.patch \
                                 0004-defconfig-change-${VER}.patch \
                                 0005-model-name-${VER}.patch"
                                 
UBOOT_PATCHES_myir-6252-am62x-k3r5 = "${UBOOT_PATCHES_myir-6252-am62x}"
UBOOT_PATCHES_myir-6254-am62x = "${UBOOT_PATCHES_myir-6252-am62x}"
UBOOT_PATCHES_myir-6254-am62x-k3r5 = "${UBOOT_PATCHES_myir-6252-am62x}"

UBOOT_PATCHES_warp-am62x = "0001-binman-symlink-change-${VER}.patch \
                                 0002-mmc-gpio-low-${VER}.patch  \
                                 0003-configure-boot-env-${VER}.patch \
                                 0004-defconfig-change-${VER}.patch \
                                 0005-model-name-${VER}.patch"
                                 
UBOOT_PATCHES_warp-am62x-k3r5 = "${UBOOT_PATCHES_warp-am62x}"

# Function to get patches for the current machine
def get_machine_patches(d):
    machine = d.getVar('MACHINE', True)
    patches = d.getVar('UBOOT_PATCHES_' + machine, True)
    if not patches:
        return ""
    
    patch_list = patches.split()
    src_uri = ""
    for patch in patch_list:
        src_uri += " file://patches/" + patch + ";unpack=1"
    return src_uri

# Add machine-specific patches to SRC_URI
SRC_URI += "${@get_machine_patches(d)}"

# Function to pre-process patches by replacing placeholders
python do_preprocess_patches() {
    import os
    import shutil
    import re
    import subprocess
    
    # Get the UBOOT_BOOT_DEVICE value from the recipe
    replace_texts = ['@UBOOT_BOOT_DEVICE@', '@CONFIG_DEFAULT_FDT_FILE@', '@CONFIG_TI_FDT_FOLDER_PATH@', '@MEMORY_TEXT_SIZE@', '@MEMORY_SIZE@']

    replace_values = [
        d.getVar('UBOOT_BOOT_DEVICE', True),
        d.getVar('CONFIG_DEFAULT_FDT_FILE', True),
        d.getVar('CONFIG_TI_FDT_FOLDER_PATH', True),
        d.getVar('MEMORY_TEXT_SIZE', True),
        d.getVar('MEMORY_SIZE', True)
    ]
    
    # Get the unpack directory
    unpackdir = os.path.join(d.getVar('UNPACKDIR', True), 'patches')

    # Get the patches for the current machine
    machine = d.getVar('MACHINE', True)
    patches = d.getVar('UBOOT_PATCHES_' + machine, True)
    
    if not patches:
        return
        
    # Process each patch file
    patch_list = patches.split()
    
    for patch in patch_list:
        # Path to the patch file in the UNPACKDIR
        patch_file = os.path.join(unpackdir, patch)
        
        # Check if the patch file exists
        if not os.path.exists(patch_file):
            bb.error("Patch file not found: %s" % patch_file)
            continue
        
        # Read the patch file from UNPACKDIR
        with open(patch_file, 'r') as f:
            content = f.read()
        
        # Replace placeholders using a loop
        for i in range(len(replace_texts)):
            if replace_texts[i] in content and replace_values[i] is not None:
                content = content.replace(replace_texts[i], replace_values[i])
        
        # Write the processed patch back to UNPACKDIR
        with open(patch_file, 'w') as f:
            f.write(content)
}

# Custom do_patch function to apply patches from UNPACKDIR
python do_patch() {
    import os
    import subprocess
    import shutil
    
    # Get the source directory
    srcdir = d.getVar('S', True)
    
    # Get the unpack directory
    unpackdir = os.path.join(d.getVar('UNPACKDIR', True), 'patches')
    
    # Get the patches for the current machine
    machine = d.getVar('MACHINE', True)
    patches = d.getVar('UBOOT_PATCHES_' + machine, True)
    
    if not patches:
        return
    
    # Create a stamp file to track which machine's patches have been applied
    stamp_file = os.path.join(srcdir, '.patches_applied_' + machine)
    
    # Check if patches for this machine have already been applied
    if os.path.exists(stamp_file):
        bb.note("Patches for machine %s already applied. Skipping." % machine)
        return
    
    # Process each patch file
    patch_list = patches.split()
    
    for patch in patch_list:
        # Path to the patch file in the UNPACKDIR
        patch_file = os.path.join(unpackdir, patch)

        # Check if the patch file exists
        if not os.path.exists(patch_file):
            bb.error("Patch file not found: %s" % patch_file)
            continue
        
        # Apply the patch using the patch command with --dry-run first to check if already applied
        try:
            # First check if the patch is already applied
            result = subprocess.call(['patch', '-p1', '-d', srcdir, '-i', patch_file, '--dry-run', '--reverse'])
            
            if result == 0:
                bb.note("Patch %s already applied to %s. Skipping." % (patch, srcdir))
                continue
            
            # If not already applied, apply it now
            subprocess.check_call(['patch', '-p1', '-d', srcdir, '-i', patch_file])
            
        except subprocess.CalledProcessError as e:
            bb.error("Failed to apply patch %s: %s" % (patch, e))
            raise
    
    # Create a stamp file to indicate patches for this machine have been applied
    with open(stamp_file, 'w') as f:
        f.write("Patches for machine %s applied\n" % machine)
}

# Add the patch pre-processing task to the build
addtask do_preprocess_patches before do_patch after do_unpack
