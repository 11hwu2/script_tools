#!/bin/awk -f

{
	if (NF == 1) {
		print "05 00 01 " $0;
	} else if (NF == 2) {
		print "15 00 02 " $0;
	} else if (NF > 2) {
		printf "39 00 %02X %s\n", NF, $0;
	}
}
