#!/usr/local/bin/bash

stime=`date +%s`
#check for command line options
if [ "$2" == "" ]; then
    echo "specify a target ip address"
    exit 0;
else
    target=$2
fi

if [ "$1" == "" ]; then
    echo "Please provide a file name for output"
    exit 0;
else if [ "$1" == "ruby" ]; then
    `./ron.rb | awk '{if($2=="$target") { print $1, $4} }' >> ruby.log`

else if [ "$1" == "ping" ]; then
    while [ true ]; do
	ctime=`date +%s`
	rtime=`expr $ctime - $stime`
	status=`ping -c 1 -t 1 $target | awk 'NR==2{ print $7 }'`
	echo "$rtime $status"
	echo "$rtime $status" >> ping.log
	sleep 1
    done
else
    echo "invalid argument: $1"
fi
fi
fi


