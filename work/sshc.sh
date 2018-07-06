#!/bin/bash

#set -x

show_usage()
{
	echo -e "  Usage: sshc <host_ip> <username>\n"
}

if  [ $# -eq 0 ] || [ $# -gt 2 ]; then
	show_usage;
	exit 1;
fi

host_ip="$1"
username="$2"

case "${host_ip}" in
	224)
	host_ip="192.168.1.224"
	;;

	66)
	host_ip="192.168.1.66"
	;;

	*)
	host_ip=''
	echo -e "  Invalid host_ip!\n"
	show_usage;
	;;

esac

ssh $host_ip -l $username 
