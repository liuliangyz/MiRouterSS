#!/bin/sh

clear
echo "-------------------------------------------------------------"
echo ""
echo "             MiRouterSS v0.1 Written by Jacky                "
echo ""
echo "-------------------------------------------------------------"

# Make sure you have install Shadowsocks
if [[ ! -f /etc/firewall.user.back ]]; then
	echo "Error: You haven't install Shadowsocks!"
	exit 1
fi

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi
# Stop ss-redir process
echo "Stop ss-redir process..."
/etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks disable

#uninstall shadowsocks
echo "Deleting Shadowsocks..."
mount / -o rw,remount
rm -f /usr/bin/ss-redir
sync
mount / -o ro,remount

cd /userdisk/data/
rm -rf MiRouterSS

# delete config file
echo "Deleting Shadowsocks config files..."
rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.back /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf
rm -f /etc/dnsmasq.d/fgset.conf


#restart all service
echo "Restart all service..."
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart

# delete shadowsocks init file
echo "Deleting shadowsocks init file..."
rm -f /etc/init.d/shadowsocks
echo "Shadowsocks uninstall success!"
echo ""
exit 0 