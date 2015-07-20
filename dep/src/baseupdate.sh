
#off services
service abrt-ccpp stop
chkconfig abrt-ccpp off
service abrt-oops stop
chkconfig abrt-oops off
service abrtd stop
chkconfig abrtd off
service acpid stop
chkconfig acpid off
service atd stop
chkconfig atd off
service autitd stop
chkconfig autitd off
service autofs stop
chkconfig autofs off
service avahi-daemon stop
chkconfig avahi-daemon off
service certmonger stop
chkconfig certmonger off
service cpuspeed start
chkconfig cpuspeed on
service cups stop
chkconfig cups off
service haldaemon start
chkconfig haldaemon on
service mdmonitor stop
chkconfig mdmonitor off
service netfs stop
chkconfig netfs off
service nfslock stop
chkconfig nfslock off
service rpcbind stop
chkconfig rpcbind off
service rpcidmapd stop
chkconfig rpcidmapd off
service rpcsvcgssd stop
chkconfig rpcsvcgssd off
service NetworkManager stop
chkconfig NetworkManager off

echo "net.core.netdev_max_backlog = 262144" >> /etc/sysctl.conf
echo "net.core.somaxconn = 4096"  >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_orphans = 327680"  >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 262144" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 30" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1024   65000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 4096 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 4096 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 94500000 915000000 927000000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_sack = 0" >> /etc/sysctl.conf
echo "fs.file-max = 1300000" >> /etc/sysctl.conf
echo "net.ipv4.ip_nonlocal_bind = 1" >>  /etc/sysctl.conf
echo "kernel.softlockup_panic = 1" >> /etc/sysctl.conf
echo "kernel.panic = 30" >> /etc/sysctl.conf
sysctl -p

mkdir -p /etc/yum.repos.d/useless
mv /etc/yum.repos.d/CentOS-* /etc/yum.repos.d/useless

#stop Ctrl+Alt+Del
sed -i "s/exec .*/#exec \/sbin\/shutdown -r now s\"Control-Alt-Delete pressed\"/g" /etc/init/control-alt-delete.conf


sed -i "s#HISTSIZE=1000#HISTSIZE=10000#g" /etc/profile
echo "HISTTIMEFORMAT=\"%Y-%m-%d %H:%M:%S \`whoami\` : \"" >>/etc/profile

echo -ne "
* soft nofile 65536
* hard nofile 65536
">>/etc/security/limits.conf

username=root
mkdir /${username}/.ssh
chmod 700 /${username}/.ssh
touch /${username}/.ssh/authorized_keys
chmod 600 /${username}/.ssh/authorized_keys
echo  -ne "
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvw0Shufrg3L3p2pq5opjeywDNJ83o5VlkWiicHmiNRe7mqfA/lGw466COQ5XuQjagRejMh8oQ2SRyZk/4j2jnRCGB3YorNE+fjXmdFcf11Z5oN8MyeX8OnE7tCZLRFiXrOgw8xRaGnW1Jw3lpejzZErtjpVJY9gkFJmSH1eZStj5bLP7enni26gLg2Fb8LjrZJxbiHwEoMuIDW3WzFP2ASwoQq+nr6lLK61kP1QL443AXM9hkqKi0AXTaOvdjokKsD7i+VrlhWXQINQoAxttphJwSNLEGKh+K6gMpwRYoeC2AZmoLBDyrX/sJPcKQCTiuL8c4mXItWThfDyJPtkV6Q== root@serv.autodeploy.cetc
" >> /${username}/.ssh/authorized_keys
filePath="/${username}/.ssh/config"
cat <<EOF > "$filePath"
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
EOF
chown -R ${username}:${username} /${username}/.ssh
