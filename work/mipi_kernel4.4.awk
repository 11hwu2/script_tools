#!/usr/bin/awk -f

# execute command: file ***.txt
# if target file format like this: ASCII text, with CRLF line terminators
# execute dos2unix ***.txt first! Or expression will be false at line 9 and line 11.

{
	if (NF == 1) {
		if ($0 == 11) {
			print "05 78 01 " $0;
		} else if ($0 == 29) {
			print "05 14 01 " $0;
		}
	} else if (NF == 2) {
		print "15 00 02 " $0;
	} else if (NF > 2) {
		printf "39 00 %02X %s\n", NF, $0;
	}
}
