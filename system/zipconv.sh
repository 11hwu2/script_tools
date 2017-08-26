#!/bin/bash

# This shell script is for converting unzip file/dir name from gbk to utf8

##############################
# 2017-08-24
##############################
LANG=C

if [ $# != 1 ]; then
	printf "Usage: zipconv.sh [file.zip]\n"
	exit 1;
fi

7z x $1 | convmv -f gbk -t utf8 --notest -r .

