#!/bin/bash

option=$1
pid_dir="run"
pid_file="${pid_dir}/cpuminer.pid"
miner=xmrig

perror(){
        [ -z "${1}" ] && msg="${1}" || msg="Unknown Error occurred!"
        printf "\033[35mError:\033[0m\t\033[31m${msg}\033[0m\n"
        }

start(){
        port='3333'
        public_address='worktips.work'
	wallet_address=''
        password=""
       	api_bind='4069'
	# diff='.100'
	workername="firstWorker"
        # Start miner process in background
        if [ ! -z "${password}" ];
        then
                nohup ./${miner} -a cryptonight-lite -o ${public_address}:${port} -u ${wallet_address} -p ${password} --api-port=${api_bind} &
        fi
        # Store process id
        _pid=($(pgrep ${miner}))
        # Create Process Directory
        if [ ! -d "${pid_dir}" ];
        then
                mkdir -v "${pid_dir}"
        fi
        # Get Last Cpuminer process id
        if [ ${#_pid[*]} -gt 1 ];
        then
                printf "Running PID: ${_pid[1]}\n"
                run_level=1
        else
                printf "Running PID: ${_pid[0]}\n"
                run_level=0
        fi
        printf "${_pid[$run_level]}" > $pid_file
        }

kill_miner(){
        if [ -f "$pid_file" ];
        then
                kill -9 `cat $pid_file`
                rm $pid_file
        else
                perror "No CPUMiner process found for this pool!"
        fi
        }

case $option in
        -s|-start)
                if [ ! -f $pid_file ];
                then
                        start
                else
                        printf "\033[32mCPUMiner is already running\033[0m\n"
                        printf "\033[35mPID:\033[0m \033[36m$(cat  $pid_file)\033[0m\n"
                fi
        ;;
        -k|-kill) kill_miner;;
        *) printf "Err: \033[31mMissing or invalid parameter was given!\033[0m\n";;
esac
