#!/bin/bash

clear 

echo "##############################################################"
c2="$(tput bold)$(tput setaf 2)"
echo "$c2 ○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○" 
echo "$c2 ○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○"
echo "$c2 ○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○"
echo "$c2 ○○▓▓○○▓▓○○○○○○○○○○○○○○○○○○○▓▓▓▓○▓▓▓○○○○○○○○○○○○○○○○○○▓▓○○○"
echo "$c2 ○○○▓○○▓○○○○○○○○○○○○○○○○○○○▓○○○▓○○○▓○○○○○○○○○○○○○○○○○○○▓○○○"
echo "$c2 ○○○▓○○▓○○○○○○○○○○○○○○○○○○○▓○○○○○○○▓○○○○○○○○○○○○○○○○○○○▓○○○"
echo "$c2 ○○○▓▓▓▓○▓▓○▓▓○○○▓▓○○○○○○○○▓○○○○○○○▓○○○○○▓▓○○▓▓○▓▓○○○▓▓▓○○○"
echo "$c2 ○○○▓○○▓○○▓○○▓○○▓○○▓○○○○○○○▓○○○○○○○▓○○○○▓○○▓○○▓○○▓○○▓○○▓○○○"
echo "$c2 ○○○▓○○▓○○▓○○▓○○○▓▓▓○○○○○○○▓○○○○○○○▓○○○○▓○○▓○○▓○○▓○○▓○○▓○○○"
echo "$c2 ○○○▓○○▓○○▓○○▓○○▓○○▓○○○○○○○▓○○○▓○○○▓○○○○▓○○▓○○▓○○▓○○▓○○▓○○○"
echo "$c2 ○○▓▓○○▓▓○○▓▓▓▓○○▓▓▓▓○○○○○○○▓▓▓○○▓▓▓▓▓○○○▓▓○○○○▓▓▓▓○○▓▓▓▓○○"
echo "$c2 ○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○"
echo "$c2 ○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○"
echo "$(tput sgr0)"   
echo "##############################################################"

singleset () {
        read -p "Are you begin set network interface(y/exit):(y)" myvar
        if [ "$myvar" = "" ]
            then
             myvar=y
        fi
	until [ "$myvar" = exit -o "$myvar" = "" ]
		do
                     if [ "$myvar" = y ]
                        then
			cd  src
			bash singleset.sh
			cd ..
			read -p  "Maybe you need to set another(y/exit):(exit)" myvar
                     else
                         singleset
                     fi
		done
             
}
bondset () {
	read -p  "Are you begin set bond network interface(y/exit):(y)" myvar
        if [ "$myvar" = "" ]
            then
             myvar=y
        fi
	until [ "$myvar" = exit -o "$myvar" = "" ]
		do
		     if [ "$myvar" = y ]
                        then
			cd src
			bash bondset.sh
			cd ..
                        read -p  "Maybe you need to set another(y/exit):(exit)" myvar
		     else 
                         bondset
                     fi
		done 
}

ntpserverset () {
        read -p  "Are you begin set NTP server(y/exit):(y)" myvar
        if [ "$myvar" = "" ]
            then
             myvar=y
        fi
        until [ "$myvar" = exit ]
                do
                 if [ "$myvar" = y ]
                   then
		    cd src
	            bash ntp.sh
	            cd ..
                    myvar=exit
                   else
                      ntpserverset
                   fi
        done
}

ntpclientset () {
        read -p "Are you begin set NTP client(y/exit):(y)"  myvar
        if [ "$myvar" = "" ]
            then
             myvar=y
        fi
        until [ "$myvar" = exit ]
                do
                 if [ "$myvar" = y ]
                  then
                    cd src
                    bash ntpclient.sh
                    cd ..
                    myvar=exit
                  else
                      ntpclientset
                  fi
        done
}

ntpset () {
        IFS=:
        PS3="please choose one: "
        ITEMS="Ntpserver:Ntpclient:Return main menu"

        select SELECTION in $ITEMS
        do
            if [ $SELECTION ]
            then
                case $SELECTION in
                    "Ntpserver" )
                                echo "The ntpserver being setup"
                                ntpserverset
                                clean
                                ;;
                    "Ntpclient" )
                                echo "The ntpclient being setup"
                                ntpclientset
                                clean
                                ;;
                    "Return main menu" )

                                main
                                ;;
                        esac
                    else
                        echo "choose between 1-3"
                    fi
                    echo "  * press enter continue next*  "
                    read
                  #  clear
                done
        }


hostnameset () {
              read -p "Are you begin set hostname(y/exit):(y)" myvar
                
              	if [ "$myvar" = y -o "$myvar" = "" ]
             	then
              		echo "Input need to set the hostname:"
              		read HOSTNAME
                        egrep 'HOSTNAME=' /etc/sysconfig/network > /dev/null
                        rtv=$?
                        if [ $rtv -eq 0 ];then
                          sed -i "s/HOSTNAME=.*/HOSTNAME=${HOSTNAME}/" /etc/sysconfig/network
                        else
                          echo "HOSTNAME=$HOSTNAME">>/etc/sysconfig/network
                        fi
                	hostname $HOSTNAME
	      	else if [ "$myvar" = "exit" ]
                        then
                        	 main
                        else
               	    	    hostnameset
                   	fi
                fi
                
}

networkset () {
	IFS=:
	PS3="please choose one: "
	ITEMS="Single:Bond:Return main menu"

	select SELECTION in $ITEMS
	do
	    if [ $SELECTION ]
	    then
	        case $SELECTION in
	            "Single" )
		                echo "The single network interface being setup"
		                singleset
		                ;;
	            "Bond" )
		                echo "The bond network interface being setup"
		                bondset
		                ;;
	            "Return main menu" )    
                                
		                main
		                ;;
		        esac
		    else
		        echo "choose between 1-3"
		    fi
		    echo "  *press enter continue*  "
		    read
		  #  clear
		done
	}

clean () {
        echo "If you want to run again, please go to /opt/software/dep , to run main.sh"
        sed -i "s#cd /opt/software/dep##g" /root/.bashrc
        sed -i "s#bash main.sh##g" /root/.bashrc
}

main () {
        # if user use Ctrl + C to interrupt this UI interface, other remote server useing cmd [ssh or scp] 
        # to this server will fail. 
        echo "Welcome to the main menu"
        echo "This script is stored in /opt/software/dep;If you want to run again,please go to and run (bash main.sh)."
        cd /opt/software/dep
	IFS=: 
	PS3="please choose one: " 
	ITEMS="Hostname:Network:Ntp:Quit" 

	select SELECTION in $ITEMS 
		do 
		    if [ $SELECTION ] 
		    then 
		        case $SELECTION in 
                            "Hostname" )
                                echo "Welcome to the hostname settings"
                                hostnameset
                                ;; 
		            "Network" ) 
		                echo "Welcome to the network settings menu"
		                networkset
		                ;; 
		            "Ntp" ) 
		                echo "Welcome to the NTP server settings" 
		                ntpset
                                clean
 		                ;; 
		            "Quit" ) 
                                clean
		                exit 
		                ;; 
		        esac 
		    else 
		        echo "choose between 1-4" 
		    fi 
			    echo "  *press enter continue*  " 
		    read 
		done 
	}

base ()
      {
       
       if [ -f "/opt/stage_flag/01_custom_os_installed" ]
          then
             return 1
          else
             echo  "Begin update system and updateing ssh,plese waiting "
	     mkdir -p  /var/log/deploy/
             cd /opt/software/dep/src
              bash baseupdate.sh  >> /var/log/deploy/01_baseupdate.log 2>&1
             cd ./updatessh
              bash updatessh.sh  >>/var/log/deploy/01_updatessh.log 2>&1
       fi
}

base
main
