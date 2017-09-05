#!/bin/bash

# This shell script is for remove some pdf password automatically
# Note: please open terminal in the dir which include input pdf file,
#	and run this, outputfile will be generated in the same dir.

##############################
# 2017-09-05	first version
##############################

#set -x

passwd=9668585735
inputfile="$1"
src_file=$(basename "$inputfile")
outputfile=unlock_"$src_file"

if [ $# != 1 ]; then
	echo "Usage: $0 [src_file.pdf]"
	exit 1;
fi

/usr/bin/qpdf --password=$passwd --decrypt $inputfile $outputfile 

if [ $? = 0 ]; then
	echo "outputfile is : $outputfile"
fi
