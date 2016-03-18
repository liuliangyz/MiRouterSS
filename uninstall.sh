#!/bin/sh

Ver='1.0'

clear
echo "-------------------------------------------------------------"
echo ""
echo "             MiRouterSS v${Ver} Written by Jacky             "
echo ""
echo "-------------------------------------------------------------"

# Make sure you have install Shadowsocks
if [[ ! -f /etc/firewall.user.bak ]]; then
	echo "Error: You haven't install Shadowsocks!"
	exit 1
fi

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi
# Remove
read -p "Do you want to unistall MiRouterSS ? (Y/n)" remove
if [[ "$remove" = "Y" ]]; then
# Stop Shadowsocks process
echo "Stop Shadowsocks process..."
/etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks disable

# Uninstall shadowsocks
echo "Deleting Shadowsocks..."
mount / -o rw,remount
rm -f /usr/bin/ss-redir
sync
mount / -o ro,remount
rm -rf /userdisk/data/MiRouterSS
echo "Deleting Shadowsocks files..."
rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.bak /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf
rm -f /etc/dnsmasq.d/fgset.conf

# Restart all service
echo "Restart all service..."
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
echo "Shadowsocks uninstall success!"
fi
exit 0 