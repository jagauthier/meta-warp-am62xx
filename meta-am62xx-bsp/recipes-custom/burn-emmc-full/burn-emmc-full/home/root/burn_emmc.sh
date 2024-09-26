#!/bin/sh

SDCARD=/dev/mmcblk1
EMMC=/dev/mmcblk0

umount /boot

# wipe the partition table
echo "Clearing EMMC partition table."
dd if=/dev/zero of=${EMMC} bs=1024 count=5 >/dev/null 2>&1 
echo "Recreating partitions."
sfdisk --force -d ${SDCARD} | sfdisk ${EMMC}

echo "Copying SD card to EMMC"
dd status=progress if=${SDCARD}p1 of=${EMMC}p1 bs=2048
dd status=progress if=${SDCARD}p2 of=${EMMC}p2 bs=2048

echo "Resizing"
(
  echo d
  echo 2
  echo n
  echo p
  echo 2
  echo 
  echo
  echo w ) | fdisk ${EMMC}

  e2fsck -y -f ${EMMC}p2
  resize2fs ${EMMC}p2

echo "Done."







