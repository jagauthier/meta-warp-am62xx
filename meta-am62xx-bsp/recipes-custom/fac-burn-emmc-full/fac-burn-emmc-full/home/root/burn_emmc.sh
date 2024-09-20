#!/bin/sh
PART=0
EMMC_NODE=/dev/mmcblk${PART}


KERNEL_DTB_DIR=/home/root/mfgimage/kernel_dtb
ROOTFS_FILE_EXT4=/home/root/mfgimage/rootfs-full.ext4

MYD_NAME="myd-am62x"


HOSTNAME=`cat /etc/hostname`

if [ x"$HOSTNAME" == x"$MYD_NAME" ];then
  led1=am62-sk:d53
  led2=am62-sk:d54

fi

LED_PID=-1
time=0.2

ECHO_TTY="/dev/ttyS2"

burn_start_ing(){

	echo "***********************************************" >> ${ECHO_TTY} 
	echo "*************    SYSTEM UPDATE    *************" >> ${ECHO_TTY} 
	echo "***********************************************" >> ${ECHO_TTY} 
	echo "***********************************************" >> ${ECHO_TTY} 
    echo "*************   Update starting   *************" >> ${ECHO_TTY}  
    echo "***********************************************" >> ${ECHO_TTY} 
    echo "                                               " >> ${ECHO_TTY} 
    echo "                                               " >> ${ECHO_TTY} 
    echo "                                               " >> ${ECHO_TTY} 
    echo "                                               " >> ${ECHO_TTY} 

	#核心板上的绿灯闪烁则烧写中
	echo 0 > /sys/class/leds/${led1}/brightness
	echo 0 > /sys/class/leds/${led2}/brightness


	while [ 1 ]
	do
		echo 1 > /sys/class/leds/${led1}/brightness
		sleep $time
		echo 0 > /sys/class/leds/${led1}/brightness
		sleep $time
        echo "*************   Updating   *************" >> ${ECHO_TTY} 
	done
}

burn_faild(){
    kill $LED_PID

	# 熄灭
	echo 0 > /sys/class/leds/${led1}/brightness

    echo "Update faild..."   >> ${ECHO_TTY} 
    echo "Update faild..."   >> ${ECHO_TTY} 
    echo "Update faild..."   >> ${ECHO_TTY} 
}

burn_succeed(){
    
    kill $LED_PID

	# 常亮
	echo 1 > /sys/class/leds/${led1}/brightness

	echo "***********************************************" >> ${ECHO_TTY} 
	echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY} 
    echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY} 
    echo "********    SYSTEM UPDATE  SUCCEED  ***********" >> ${ECHO_TTY} 
	echo "***********************************************" >> ${ECHO_TTY} 
    echo "***********************************************" >> ${ECHO_TTY} 
    echo "                                               " >> ${ECHO_TTY} 

}

echo_fun(){
	echo "***********************************************" >> ${ECHO_TTY} 
	echo "********    "$1 "  ***********" >> ${ECHO_TTY}
    echo "***********************************************" >> ${ECHO_TTY} 
}

cmd_check()
{
	if [ $1 -ne 0 ];then
		echo "$2 failed!"   >> ${ECHO_TTY}
        echo "$2 failed!"   >> ${ECHO_TTY}
        echo "$2 failed!"   >> ${ECHO_TTY}
		burn_faild 
        exit -1
	fi
}

mksdcard(){
    #partition size in 100M
    BOOT_ROM_SIZE=100
    KERNEL_DTB_SIZE=120

    if [   $# -lt 1 ];then
	echo format node not exist
        exit 1
    else
	echo exist
    fi
    node=$1
    echo $node

    dd if=/dev/zero of=${node} bs=1024 count=5

    
    
sfdisk --force ${node} <<EOF
    ${BOOT_ROM_SIZE}M,${KERNEL_DTB_SIZE}M,0c
    $(($KERNEL_DTB_SIZE + 10))M,,83
EOF
    while [ 1 ]
    do
	if [ -b ${node}p2 ];then
		break
	else
		sleep 0.5
		echo ${node}p2 not exist
	fi
    done
}

enable_bootpart(){
    mmc bootpart enable 1 1 /dev/mmcblk${PART}
    mmc bootbus set single_backward x1 x8 /dev/mmcblk0
    mmc hwreset enable /dev/mmcblk0
    mmc extcsd read /dev/mmcblk0 | grep RST
}


burn_kernel_dtb(){
    mkfs.vfat  /dev/mmcblk${PART}p1
    mkdir -p /mnt/mmcblk${PART}p1
    mount -t vfat /dev/mmcblk${PART}p1 /mnt/mmcblk${PART}p1
    cp ${KERNEL_DTB_DIR}/* /mnt/mmcblk${PART}p1
    
    echo 0 > /sys/block/mmcblk0boot0/force_ro
    dd if=${KERNEL_DTB_DIR}/tiboot3.bin of=/dev/mmcblk0boot0 bs=512 seek=0
    dd if=${KERNEL_DTB_DIR}/tispl.bin of=/dev/mmcblk0boot0 bs=512 seek=1024
    dd if=${KERNEL_DTB_DIR}/u-boot.img  of=/dev/mmcblk0boot0 bs=512 seek=5120
    
    cmd_check $? "burn kernel dtb faild"
    sync
}

burn_rootfs_ext4(){
    # start_time=`date +%s`
    mkfs.ext4  /dev/mmcblk${PART}p2 <<EOF
y
EOF
    dd if=${ROOTFS_FILE_EXT4} of=/dev/mmcblk${PART}p2 bs=1M
    cmd_check $? "burn root faild"
    sync
    # end_time=`date +%s`
    # echo rootfs time:$(($end_time - $start_time))
}

reszie2fs_mmc(){
    resize2fs /dev/mmcblk${PART}p2
    cmd_check $? "reszie2fs mmc faild"
    sync
}

check_rootfs(){
    mkdir -p /mnt/mmcblk${PART}p2
    mount /dev/mmcblk${PART}p2 /mnt/mmcblk${PART}p2
    rootfs_hostname=`cat /mnt/mmcblk${PART}p2/etc/hostname`
    echo_fun "rootfs_hostname:$rootfs_hostname"

    if [ x"$rootfs_hostname" != x"$HOSTNAME" ];then
       echo_fun "not equal"
       reboot
    else
       echo_fun "equal"
    fi
}

hw_reset(){
    mmc hwreset enable /dev/mmcblk0
}

burn_start_ing &
LED_PID=$!
sleep 1
echo_fun "start format mmc "
mksdcard ${EMMC_NODE}
echo_fun "start burn dtb and kernel "
burn_kernel_dtb
hw_reset
echo_fun "start burn rootfs "
burn_rootfs_ext4
echo_fun "start burn uboot "
reszie2fs_mmc
check_rootfs
enable_bootpart
burn_succeed


