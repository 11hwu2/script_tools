#!/bin/awk -f

# execute command: file ***.txt
# if target file format like this: ASCII text, with CRLF line terminators
# execute dos2unix ***.txt first! Or you will get something like below.
#
# rockchip,on-cmds1 {
# compatible = "rockchip,on-cmds";
# rockchip,cmd_type = <LPDT>;
# rockchip,dsi_id = <0>;
# >;ckchip,cmd = <0x15 0xB0 0x00
# rockchip,cmd_delay = <0>;
# };
#

{
	printf "\nrockchip,on-cmds%d {\n", NR
	printf "compatible = \"rockchip,on-cmds\";\n"
	printf "rockchip,cmd_type = <LPDT>;\n"
	printf "rockchip,dsi_id = <0>;\n"
	printf "rockchip,cmd = <"
	delay = 0;
	if (NF == 1) {
		printf "0x05 %s", $0
		if ($0 == "0x11")
			delay = 120;
		else if ($0 == "0x29")
			delay = 20;
	} else if (NF == 2) {
		printf "0x15 %s", $0
	} else if (NF > 2) {
		printf "0x39 %s", $0
	}
	#printf "\n"
	printf ">;\n"
	printf "rockchip,cmd_delay = <%d>;\n", delay
	printf "};\n"
}
