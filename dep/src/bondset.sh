#!/bin/bash

source ./lib/network.sh
source ./lib/iplist.sh

############################配置IP脚本#####################################
fun0 () {
        srcfile="bond/ifcfg-eth"
        srcfile2="bond/ifcfg-bond"
        ipfile="/etc/sysconfig/network-scripts/ifcfg-${ETH}"
        ipfile2="/etc/sysconfig/network-scripts/ifcfg-${ETH2}"
        bondfile="/etc/sysconfig/network-scripts/ifcfg-bond${MODE}"
        nwfile="/etc/sysconfig/network"
        \cp $srcfile $ipfile
        \cp $srcfile $ipfile2
        \cp $srcfile2 $bondfile
        sed -i "s#^DEVICE=.*#DEVICE=${ETH}#g" $ipfile
        sed -i "s#MASTER=.*#MASTER=bond${MODE}#g" $ipfile
        sed -i "s#^DEVICE=.*#DEVICE=${ETH2}#g" $ipfile2
        sed -i "s#MASTER=.*#MASTER=bond${MODE}#g" $ipfile2
        sed -i "s#^DEVICE=.*#DEVICE=bond${MODE}#g" $bondfile
        echo "alias bond${MODE} bonding" >> /etc/modprobe.d/bonding.conf
        echo "options bond${MODE} miimon=100 mode=${MODE}">>/etc/modprobe.d/bonding.conf
}

mode ()
    {
        read -p  "Enter the bond mode that you want to set(0,1,2,3,4,5,6):" MODE
        if [ "$MODE" = "0" -o "$MODE" = "1" -o "$MODE" = "2" -o "$MODE" = "3" -o  "$MODE" = "4" -o "$MODE" = "5" -o "$MODE" = "6"  ]
             then 
                return 1
             else
                 mode
        fi
        
     }   
eth ()
     { 
        echo "interfaces  list and ips list :"
	iplist
	read -p  "Enter the device1 that you want to set:" ETH
        read -p  "Enter the device2 that you want to set:" ETH2
        if [ "$ETH" = "" -o "$ETH2" = "" ]
            then
                echo "Error! Plese input interfaces from list"
                eth
        else
             TEST1=`ifconfig -a |grep HWaddr|awk '{print $1'}|grep $ETH`
             TEST2=`ifconfig -a |grep HWaddr|awk '{print $1'}|grep $ETH2`
             if [ "$TEST1" = "" -o "$TEST2" = "" -o "$ETH" = "$ETH2" ]
                 then
                        echo "Error! Plese input interfaces from list"
                        eth
             fi
	
        fi
}

fun1 ()
{        
	inputip
        inputnetmask
        inputGW
        inputdns
	HOSTNAME=`hostname`
        
        echo "bond=bond${MODE},interface1=${ETH},inteface2=${ETH2},IP=${IP},NETMASK=${netmask},GATEWAY=${gateway},DNS=${dns},HOSTNAME=$HOSTNAME"
	

}

set()
{

        fun1
        fun0
        echo "BOOTPROTO=none" >>$bondfile
        echo "NETMASK=$netmask" >>$bondfile
        echo "IPADDR=$IP" >>$bondfile
        sed -i "/GATEWAY.*/d" $nwfile
        echo "GATEWAY=$gateway" >>$nwfile
        echo "DNS1=$dns">>$bondfile
        echo "nameserver $dns" > /etc/resolv.conf
        sed -i '/ifenslave.*/d' /etc/rc.d/rc.local
        echo "ifenslave bond${MODE} ${ETH} ${ETH2}" >>/etc/rc.d/rc.local
        [ "${HOSTNAME}" != "localhost" ] &&  sed -i "/.*${HOSTNAME}.*/d" /etc/hosts
	echo "$IP	$HOSTNAME" >>/etc/hosts
        modprobe bonding
        service network restart
}

mode
eth
set
