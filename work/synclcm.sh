#!/bin/bash

# This shell is for sync lcm driver files from lk to kernel or from kernel to lk when develop
# It can only execute in lk/kernel dir!!!

#######################################
# 2017-05-08	first version
#######################################
# 2017-07-15	second version
#	support in kernel dir
#######################################
#set -x
path=$(pwd)
work_dir=$(basename "${path}")

show_usage()
{
	printf "\nUsage: synclcm.sh [lcm_dir]\n\n"
	printf "Param [lcm_dir] is the dir needed to sync,\n"
	printf "and you can type its full or relative path.\n\n"
}

check_dir()
{
	local dir=$1
	if [ "$dir" = lk ] || [ "${dir:0:6}" = kernel ]; then
		return 0
	else
		printf "\n\nPlease run this script in LK or Kernel dir!!!\n\n"
		return 1
	fi
}

if [ $(check_dir "$work_dir") ] || [ $# != 1 ]; then
	show_usage;
	exit 1;
fi

if [ "$work_dir" = lk ]; then
	src_tree=${path%vendor*}
	kernel_path=$src_tree/kernel-[0-9].*
	printf "Copy dir from lk to kernel...\n"
	cp -r $1 $kernel_path/drivers/misc/mediatek/lcm/
else
	src_tree=${path%kernel*}
	lk_path=$src_tree/vendor/mediatek/proprietary/bootable/bootloader/lk
	printf "Copy dir from kernel to lk...\n"
	cp -r $1 $lk_path/dev/lcm/
fi
printf "Sync done.\n"
