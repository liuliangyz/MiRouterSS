#!/bin/sh

Ver='1.0'

clear
echo "-------------------------------------------------------------"
echo ""
echo "             MiRouterSS v${LNMP_Ver} Written by Jacky        "
echo ""
echo "-------------------------------------------------------------"

read -p "Do you want to unistall MiRouterSS ? (Y/n)" uninstallSS
if [[ "$uninstallSS" = "Y" ]]; then
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

cd /userdisk/data/
rm -rf MiRouterSS

# Delete config file
echo "Deleting Shadowsocks config files..."
rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.bak /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf
rm -f /etc/dnsmasq.d/fgset.conf


# Restart all service
echo "Restart all service..."
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart

# Delete shadowsocks init file
echo "Deleting shadowsocks init file..."
rm -f /etc/init.d/shadowsocks
echo "Shadowsocks uninstall success!"
echo ""
fi
exit 0 