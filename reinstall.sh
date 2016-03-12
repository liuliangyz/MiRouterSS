#!/bin/sh

Ver='1.0'

clear
echo "-------------------------------------------------------------"
echo ""
echo "              Reinstall Shadowsocks For MiRouter             "
echo ""
echo "              MiRouterSS v${Ver} Written by Jacky            "
echo ""
echo "-------------------------------------------------------------"

read -p "Do you want to reinstall MiRouterSS ？ (Y/n)" reinstallSS
if [[ "$reinstallSS" = "Y" ]]; then
# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi

echo "Reinstalling MiRouterSS..."
# Stop ss-redir process
/etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks disable

# Uninstall shadowsocks
mount / -o rw,remount
rm -f /usr/bin/ss-redir
sync
mount / -o ro,remount

cd /userdisk/data/
rm -rf MiRouterSS

# Delete config file
rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.bak /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf
rm -f /etc/dnsmasq.d/fgset.conf

# Restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart

# Delete shadowsocks init file
rm -f /etc/init.d/shadowsocks

# Uncompress ShadowSocks
cd /userdisk/data/
if [[ -f MiRouterSS.tar.gz ]]; then
rm -f MiRouterSS.tar.gz && rm -f MiRouterSS
fi
wget http://dl.jackyu.cn/attachments/MiRouterSS/MiRouterSS.tar.gz
tar zxf MiRouterSS.tar.gz

# Install shadowsocks ss-redir to /usr/bin
mount / -o rw,remount
cp -f ./MiRouterSS/ss-redir  /usr/bin/ss-redir
chmod +x /usr/bin/ss-redir
sync
mount / -o ro,remount

# Config shadowsocks init script
cp ./MiRouterSS/shadowsocks /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks

# Config ShadowSocks setting
cp -f /userdisk/data/MiRouterSS/Backup/config.json /etc/shadowsocks/config.json

# Config dnsmasq
mkdir -p /etc/dnsmasq.d
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgserver.conf --insecure > /etc/dnsmasq.d/fgserver.conf
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgset.conf --insecure > /etc/dnsmasq.d/fgset.conf

#config firewall
cp -f /etc/firewall.user /etc/firewall.user.bak
echo "ipset -N setmefree iphash -! " >> /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp -m set --match-set setmefree dst -j REDIRECT --to-port ${localport}" >> /etc/firewall.user

# Restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
/etc/init.d/shadowsocks start
/etc/init.d/shadowsocks enable

# Install successfully
rm -rf /userdisk/data/ShadowSocksForMiRouter
rm -rf /userdisk/data/ShadowSocksForMiRouter.tar.gz
echo "-------------------------------------------------------------"
echo ""
echo "       Congratulations, MiRouterSS Reinstalled complete!     "
echo ""
echo "-------------------------------------------------------------"
echo ""
fi
exit 0
