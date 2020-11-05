#!/bin/bash
#后台挂起命令
#nohup ./ping_something.sh [ipaddr] > [log_file] 2>&1 &


addr=$1

while true;
do
    # ping一次一般在第二行，根据情况修改
    ping $addr -c 1 | sed -n '2p' | awk '{print strftime("%H:%M:%S", systime()) "\t" $0}'
    sleep 1
done