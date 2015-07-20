#!/bin/bash  
############################################################  
####      update openssl openssh script             ########  
####                                                #######   
############################################################  
sleep 5  
export PATH=$PATH:/sbin/  
####  yum local #####  
cd ./lib
rpm -ivh *.rpm 
cd ..
####install openssh########
version=6.6p1
cpu=`cat /proc/cpuinfo|grep processor|wc -l`
cd ./src  
tar -zxvf openssh-${version}.tar.gz  
cd openssh-${version}   
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-ssl-dir=/usr/local/openssl --with-md5-passwords --mandir=/usr/share/man --with-zlib=/usr/local/zlib --without-openssl-header-check  
make -j ${cpu} 
#rpm -e openssh --nodeps 
rpm -e openssh-server --nodeps
#rpm -e openssh-clients --nodeps 
make install  
cp ./contrib/redhat/sshd.init /etc/init.d/sshd  
chmod +x /etc/init.d/sshd  

#change ssh_config
sed -i "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config
sed -i "s/^GSSAPICleanupCredentials yes/GSSAPICleanupCredentials no/g" /etc/ssh/sshd_config
sed -i "s/^GSSAPIAuthentication yes/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/^UsePrivilegeSeparation sandbox.*/#UsePrivilegeSeparation sandbox/g" /etc/ssh/sshd_config
sed -i "s/GSSAPIAuthentication yes/#       GSSAPIAuthentication yes/g" /etc/ssh/ssh_config

chkconfig sshd on  
service sshd start  
openssl version -a  
ssh -V 

mkdir -p /opt/stage_flag/
touch /opt/stage_flag/01_custom_os_installed

#sed -i "s#cd /opt/software/updatessh##g" /etc/rc.local
#sed -i "s#bash updatessh.sh##g" /etc/rc.local
cd ..
rm -rf openssh-${version}
exit
