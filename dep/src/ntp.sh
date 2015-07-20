#!/bin/bash

source ./lib/network.sh


echo "Ntpserver setting!!!"

read -p  "plese input ntp_server's IP: " NTPIP

IP=`ifconfig -a|grep "inet addr"|grep -v "127.0.0.1"|awk -F ":" '{print $2}'|awk '{print $1}'`



srcfile="ntp/ntp.conf"
dscfile="/etc/ntp.conf"



mv /etc/ntp.conf{,.orig}

\cp $srcfile $dscfile

for a in $IP
do
echo "server $a" >>$dscfile
done

if [ "$NTPIP" != "" ]
   then
	sed -i -e '/server  127.127.1.0/a\server  '"$NTPIP"'\' $dscfile
	service ntpd stop
   	ntpdate $NTPIP
 
fi

service ntpd stop

ntpdate 3.cn.pool.ntp.org
hwclock -w

chkconfig ntpd on  
service ntpd start
