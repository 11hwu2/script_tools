#!/bin/bash

# This shell script is for pacakge MTK Android firmware from out/product/$(project)
# NOTE: Get output dir from env variant, so make sure export ANDROID_PRODUCT_OUT before pack!

#set -x

scatter_file_6753="MT6753_Android_scatter.txt"
scatter_file_6757="MT6757_Android_scatter.txt"
scatter_file_6797="MT6797_Android_scatter.txt"
scatter_file_6799="MT6799_Android_scatter.txt"

show_usage()
{
	printf "\nUsage: pack.sh filename.tar.gz\n"
	printf "  Please exec build/envsetup.sh and lunch project before using this!\n"
}

if [ $# != 1 ] || [ -z $ANDROID_PRODUCT_OUT ]; then

	show_usage;
	exit 1;
fi

cd $ANDROID_PRODUCT_OUT
echo "Enter dir '$ANDROID_PRODUCT_OUT'"

if [ -e "$scatter_file_6753" ]; then
	scatter_file="$scatter_file_6753"

elif [ -e "$scatter_file_6757" ]; then
	scatter_file="$scatter_file_6757"

elif [ -e "$scatter_file_6797" ]; then
	scatter_file="$scatter_file_6797"

elif [ -e "$scatter_file_6799" ]; then
	scatter_file="$scatter_file_6799"
fi

echo "scatter file name: $scatter_file"

file_list="`sed -n '/file_name: [a-z]/p' $scatter_file | sort -u | awk '{print $2}' | tr '\n' ' '`"

echo "Compress file..."

tar czvf $1 $file_list

echo "Done!"
