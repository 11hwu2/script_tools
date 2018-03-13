#!/bin/bash

#set -x

show_usage()
{
	printf "\nUsage: push_metadata.sh \n"
	printf "  Please exec build/envsetup.sh and lunch project before using this!\n"
}

if [ -z $ANDROID_PRODUCT_OUT ]; then
	show_usage;
	exit 1;
fi

cd $ANDROID_PRODUCT_OUT

echo -e "Enter dir $OUT, will start push..."

adb wait-for-device

adb remount

adb wait-for-device

adb push system/vendor/lib64/libmtkcam_metastore.so system/vendor/lib64/

adb push system/vendor/lib/libmtkcam_metastore.so system/vendor/lib/

adb push system/vendor/lib64/libcam.halsensor.so system/vendor/lib64/

adb push system/vendor/lib/libcam.halsensor.so system/vendor/lib/
