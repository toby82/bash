#!/bin/bash
source ./lib/network.sh
source ./lib/iplist.sh
############################配置IP脚本#####################################
fun0 () {
        srcfile="single/ifcfg-eth"
        ipfile="/etc/sysconfig/network-scripts/ifcfg-${ETH}"
        nwfile=/etc/sysconfig/network
        \cp $srcfile $ipfile
        sed -i "s#^DEVICE=.*#DEVICE=${ETH}#g" $ipfile
}
fun1 () {
        inputip
        inputnetmask
        inputGW
        inputdns
	HOSTNAME=`hostname`
echo "interface=$ETH IP=$IP,NETMASK=$netmask,GATEWAY=$gateway,DNS=$dns,HOSTNAME=$HOSTNAME"
}

eth()
{
echo "interfaces  list and ips list :"
iplist

read -p "Enter the device that you want to set:" ETH
if [ "$ETH" = "" ]
     then
	echo "Error! Plese input interfaces from list"
        eth
     else
         num2=`ifconfig -a |grep HWaddr|awk '{print $1'}|grep $ETH`
         if [ "$num2" = "" ]
                then
		   echo "Error! Plese input interfaces from list"
                   eth
         fi

fi
}


set()
{
read -p "Enter the IP model you want to set (DHCP/STATIC):" model

if [ "$model" = "DHCP" -o "$model" = "dhcp" ]
then
        fun0
        echo "BOOTPROTO=dhcp" >>$ipfile
        service network restart
elif [ "$model" = "STATIC" -o "$model" = "static" ]
then
        fun1
        fun0
        echo "BOOTPROTO=none" >>$ipfile
        echo "NETMASK=$netmask" >>$ipfile
        echo "IPADDR=$IP" >>$ipfile
        sed -i "/GATEWAY.*/d" $nwfile
        echo "GATEWAY=$gateway" >>$nwfile
        echo "DNS1=$dns" >>$ipfile
        echo "nameserver $dns" > /etc/resolv.conf
        [ "${HOSTNAME}" != "localhost" ] &&  sed -i "/.*${HOSTNAME}.*/d" /etc/hosts
	echo "$IP       $HOSTNAME" >>/etc/hosts
        service network restart

else
        echo "error:please enter DHCP or STATIC"
        set
fi
}

eth
set
