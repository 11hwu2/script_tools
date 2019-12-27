#!/bin/bash

######################################
#	Version: 2019-12-20
######################################

. build/envsetup.sh >/dev/null && setpaths

#set -x

######################################
#	custom area start
######################################
FIRMWARE_NAME=rk3326_android_8.1_m1011qr_gc0312_ov2680_rtl8723ds
KERNEL_CONFIG_PATH=arch/arm64/configs/rk3326_m1011qr_defconfig
KERNEL_DTS_PATH=arch/arm64/boot/dts/rockchip/rk3326-m1011qr.dts
DMC_FILE_PATH=arch/arm64/boot/dts/rockchip/px30.dtsi

## system-status-freq property in dmc node
#
#1744         system-status-freq = <
#1745             /*system status         freq(KHz)*/
#1746             SYS_STATUS_NORMAL       450000
#1747             SYS_STATUS_REBOOT       450000
#1748             SYS_STATUS_SUSPEND      450000
#1749             SYS_STATUS_VIDEO_1080P  450000
#1750             SYS_STATUS_BOOST        450000
#1751             SYS_STATUS_ISP          450000
#1752             SYS_STATUS_PERFORMANCE  450000
#1753         >;
#
SYS_FREQ_START_LINE=1744
SYS_FREQ_END_LINE=$[$SYS_FREQ_START_LINE + 9]

## fixed freq opp table, disable other opp tables
#1800         opp-450000000 {
#1801             opp-hz = /bits/ 64 <450000000>;
#1802             opp-microvolt = <1050000>;
#1803             opp-microvolt-L0 = <1050000>;
#1804             opp-microvolt-L1 = <1000000>;
#1805             opp-microvolt-L2 = <975000>;
#1806             opp-microvolt-L3 = <950000>;
#1807         };
#
OPP_FREQ_START_LINE=1800
OPP_FREQ_END_LINE=$[$OPP_FREQ_START_LINE + 1]

## fixed ddr freq
FREQ_START=450
FREQ_STEP=30
FREQ_NUM=10
######################################
#	custom area end
######################################

KERNEL_CONFIG=${KERNEL_CONFIG_PATH#*configs/}
KERNEL_DTS=${KERNEL_DTS_PATH#*rockchip/}
KERNEL_IMG=${KERNEL_DTS/dts/img}
MAKE_JOBS=32

SDK_PATH=`pwd`
KERNEL_ARCH=`get_build_var TARGET_ARCH`
TARGET_PRODUCT=`get_build_var TARGET_PRODUCT`
IMAGE_PATH=rockdev/Image-$TARGET_PRODUCT
PACK_PATH=RKTools/linux/Linux_Pack_Firmware/rockdev-pcba
PACK_FIRST="true"
PACK_DATE=`date +%Y%m%d`

make_kernel_config()
{
	if [ -z $KERNEL_ARCH ]; then
		echo -e "kernel arch is null, source and lunch first please!"
		exit 1;
	fi

	if [ -d kernel ]; then
		cd kernel
		make ARCH=$KERNEL_ARCH $KERNEL_CONFIG
	fi
}

make_kernel_img()
{
	make ARCH=$KERNEL_ARCH $KERNEL_IMG -j$MAKE_JOBS
	cd $SDK_PATH
}

modify_ddr_freq()
{
	cd $SDK_PATH/kernel
	sed -i "${SYS_FREQ_START_LINE},${SYS_FREQ_END_LINE}s/$1/$2/" $DMC_FILE_PATH
	sed -i "${OPP_FREQ_START_LINE},${OPP_FREQ_END_LINE}s/$1/$2/" $DMC_FILE_PATH
}

pack_pcba_firmware()
{
	if [ ${PACK_FIRST} = "true" ]; then
		rm -rf $PACK_PATH/Image
		rm -rf $PACK_PATH/*.img
		cp -arvf $IMAGE_PATH $PACK_PATH/Image
	else
		cp $SDK_PATH/kernel/resource.img $SDK_PATH/$PACK_PATH/Image/
	fi
	PACK_FIRST="false"

	cd $PACK_PATH
	./mkupdate.sh

	mv update.img ${FIRMWARE_NAME}_${1}M_$PACK_DATE.img
	echo -e "\nMaking ${FIRMWARE_NAME}_${1}M_$PACK_DATE.img OK."
	cd $SDK_PATH
}


FREQ_TMP=$FREQ_START
make_kernel_config

for ((i=0; i < $FREQ_NUM; i++))
do
	modify_ddr_freq	$FREQ_TMP $[$FREQ_START + $FREQ_STEP * i]
	make_kernel_img
	pack_pcba_firmware $[$FREQ_START + $FREQ_STEP * i]
	FREQ_TMP=$[$FREQ_START + $FREQ_STEP * i]
done

echo -e "\n Making all pcba test firmware OK!"

