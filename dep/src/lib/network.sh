#! /bin/bash

function checkip ()
{
echo $1 |grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$" > /dev/null  
num=$? 
if [ "$num" = 1 ]
   then
        return 1
else
	for var in `echo $1 | awk -F. '{print $1, $2, $3, $4}'`
		do
			if [ $var -ge 0 -a $var -le 255 ]
			then
				continue
			else
				return 1
			fi
	done
fi
}

function inputip ()
        {
        read -p  "Enter the IP that you want to set:" IP
         
        if [ "$IP" = "" ]
            then 
                 inputip
           else 
              checkip $IP
              if [ "$?" = 1  ]
                 then
                 echo " IP  error, plese input again "
                 inputip
             fi
        fi
     }



function inputnetmask ()
        {
        
        read -p  "Enter the netmask:(default 255.255.255.0)" netmask

        if [ "$netmask" = "" ]
            then
                 netmask="255.255.255.0"
           else
              checkip $netmask
              if [ "$?" = 1  ]
                 then
                 echo " Netmask  error, plese input again "
                 inputnetmask
             fi
        fi
     }

function inputGW ()
        {
        read -p  "Enter the gateway:" gateway

        if [ "$gateway" = "" ]
            then
                 return 1
           else
              checkip $gateway
              if [ "$?" = 1  ]
                 then
                 echo " Gwateway error, plese input again "
                 inputGW
             fi
        fi
     }

function inputdns ()
        {
        read -p "Enter the DNS:" dns
        if [ "$dns" = "" ]
            then
                 return 1
           else
              checkip $dns
              if [ "$?" = 1  ]
                 then
                 echo " DNS  error, plese input again "
                 inputdns
             fi
        fi
     }

function inputnw ()
        {
	read -p  "Enter access network(192.168.0.0):" network

        if [ "$network" = "" ]
            then
                 inputnw
           else
              checkip $network
              if [ "$?" = 1  ]
                 then
                 echo " network  error, plese input again "
                 inputnw
             fi
        fi
     }

