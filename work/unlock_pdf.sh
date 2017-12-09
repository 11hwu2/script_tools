#!/bin/bash

# This shell script is for remove some pdf password automatically
# Note: please open terminal in the dir which include input pdf file,
#	and run this, locked file will be unlocked.

############################################################
# 2017-09-05	first version
############################################################
# 2017-12-09	unlock file in /tmp, unlocked files keep 
#		same name with locked
############################################################

#set -x

passwd=9668585735
inputfile="$1"
src_file=$(basename "$inputfile")
outputfile=unlock_"$src_file"

if [ $# != 1 ]; then
	echo "Usage: $0 [src_file.pdf]"
	exit 1;
fi

tmpdir=$(mktemp -dt unlock_pdf.XXXXXX)

mv "$inputfile" "$tmpdir"

/usr/bin/qpdf --password=$passwd --decrypt "$tmpdir/$inputfile" "$tmpdir/$outputfile"

cp "$tmpdir/$outputfile" "$inputfile"

if [ $? = 0 ]; then
	echo "unlock successfully!"
fi
