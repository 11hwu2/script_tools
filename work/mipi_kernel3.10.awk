#!/bin/awk -f

{
	printf "\nrockchip,on-cmds%d {\n", NR
	printf "compatible = \"rockchip,on-cmds\";\n"
	printf "rockchip,cmd_type = <LPDT>;\n"
	printf "rockchip,dsi_id = <0>;\n"
	printf "rockchip,cmd = <"
	if (NF == 1) {
		printf "0x05 %s", $0
	} else if (NF == 2) {
		printf "0x15 %s", $0
	} else if (NF > 2) {
		printf "0x39 %s", $0
	}
	#printf "\n"
	printf ">;\n"
	printf "rockchip,cmd_delay = <0>;\n"
	printf "};\n"
}
