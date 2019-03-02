#!/bin/bash


option="$1"

err(){
	if [ -z "$1" ];
	then
		err_msg="Unknown error occurred!"
	else
		err_msg="$1"
	fi
	printf "\033[35mError:\033[0m\t\033[31m${err_msg}\033[0m\n"
	}

help_menu(){
	printf "Toggler Daemonizer Switch\n"
	printf "Run Daemonizer\t[ -r, -run, --run ]\n"
	printf "Kill Daemonizer\t[ -k, -kill, --kill ]\n"
	printf "Help Menu\t[ -h, -help, --help ]\n"
	}

case $option in
	-r|-run|--run)
		if [ ! -f "toggler.run" ];
		then
			touch "toggler.run"
			echo "Switch Toggler On"
			./daemon_wrapper &
		else
			echo "Toggler Switch is On"
			if [ ! -z "$(pgrep daemon_wrapper)" ];
			then
				printf "No Daemonized Wrapper Found!"
			else
				printf "Wrapper is Running: [ \033[32m$(pgrep daemon_wrapper)\033[0m ]"
			fi
		fi
	;;
	-k|-kill|--kill)
	find ./ -type f -name "toggler.run" -delete && echo "Switch Toggler Off"
		if [ ! -z "$(pgrep daemon_wrapper)" ];
		then
			kill -15 $(pgrep daemon_wrapper)
			./miner_wrapper.sh -k
		fi
	;;
	-h|-help|--help) help_menu;;
	*) err "Missing or invalid parameter was entered!";;
esac
