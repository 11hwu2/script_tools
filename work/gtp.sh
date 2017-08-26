#!/bin/bash

# This shell script is for formatting Goodix config. After that, we can copy the formatted
# code to *config.h file

####################################
# 2017-08-24	first version
####################################

#set -x

inputfile=$1
outputfile=$1.bak

show_usage()
{
	printf "\nUsage: gtp.sh [config_file]\n\n"
	printf "
full path or relative path will ok,
outfile will be generated in current dir,
default name is 'config_file.bak'\n"

}

if [ $# != 1 ]; then
	show_usage;
	exit 1;
fi

/usr/bin/awk -F , '{ for(i=0; i<24; i++) {for(j=1;j<11;j++) printf("%s,", $(i*10+j)); printf(" \\\n");} }' $inputfile > $outputfile

/bin/sed -i 's/,,//' $outputfile

printf "Format done\n"
