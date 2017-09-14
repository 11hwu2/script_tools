#!/bin/bash

# This is for special USB device connect/disconnect to vbox guest OS efficiently!
# For me, it is for MTK flash tool to use MTK preloader.

# NOTE:
#	1. Use VBoxManage showvminfo <uuid|vmname> to get some info, find USB Device Filters, get
#	the index, name, vendorid, productid of the usb device that you want
#
#	2. Modify the cooresponding variant below and test this shell script, enjoy it!

#set -x

Vmname="win7"
Index=0
Name="MediaTek MT65xx Preloader [0100]"
VendorId=0e8d
ProductId=2000

show_usage()
{
	echo -e "Usage:"
	echo -e " vbox_usbfilter.sh yes|no"
	echo -e " yes: vbox guest OS use"
	echo -e " no : host OS use"
}

if [ $# != 1 ] || [ "$1" != "yes" ] && [ "$1" != "no" ]; then
	show_usage;
	exit 1;	
fi

/usr/bin/VBoxManage usbfilter modify "$Index" --target "$Vmname" --name "$Name" --vendorid "$VendorId" --productid "$VendorId" --active "$1"

