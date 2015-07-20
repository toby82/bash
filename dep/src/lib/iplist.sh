#!/bin/bash
function iplist () {
num=`ifconfig -a |grep HWaddr|awk '{print $1'}`
for i in $num
	do
		ip=`ifconfig $i| awk '/inet addr/ {split($2,x,":");print x[2]}'`
		echo "$i:$ip"
	done
}
