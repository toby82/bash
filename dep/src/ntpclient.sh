#!/bin/bash
source ./lib/network.sh

echo "plese input ntp_server's IP !!!"

inputip

/usr/sbin/ntpdate $IP&& /sbin/hwclock -w

sed -i '/ntpdate.*hwclock/d' /etc/crontab
echo "*/5 * * * * root /usr/sbin/ntpdate $IP&& /sbin/hwclock -w" >> /etc/crontab
