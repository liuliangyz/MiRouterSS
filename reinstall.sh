#!/bin/sh

clear
echo "-------------------------------------------------------------"
echo ""
echo "              Reinstall Shadowsocks For Miwifi               "
echo ""
echo "              MiRouterSS v0.1 Written by Jacky               "
echo ""
echo "-------------------------------------------------------------"

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi

echo "Reinstalling MiRouterSS..."
# Stop ss-redir process
/etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks disable

#uninstall shadowsocks
mount / -o rw,remount
rm -f /usr/bin/ss-redir
sync
mount / -o ro,remount

cd /userdisk/data/
rm -rf MiRouterSS

# delete config file
rm -rf /etc/shadowsocks
mv -f /etc/firewall.user.back /etc/firewall.user
rm -f /etc/dnsmasq.d/fgserver.conf
rm -f /etc/dnsmasq.d/fgset.conf

#restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart

# delete shadowsocks init file
rm -f /etc/init.d/shadowsocks

# Uncompress ShadowSocks
cd /userdisk/data/
rm -f ShadowSocksForMiRouter.tar.gz
cp -f MiRouterSS/ShadowSocksForMiRouter.tar.gz ./
tar zxf ShadowSocksForMiRouter.tar.gz

# Install shadowsocks ss-redir to /usr/bin
mount / -o rw,remount
cp -f ./ShadowSocksForMiRouter/ss-redir  /usr/bin/ss-redir
chmod +x /usr/bin/ss-redir
sync
mount / -o ro,remount

# Config shadowsocks init script
cp ./ShadowSocksForMiRouter/shadowsocks /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks

# Config ShadowSocks setting
cp -f /userdisk/data/MiRouterSS/Backup/config.json /etc/shadowsocks/config.json

# Config dnsmasq
mkdir -p /etc/dnsmasq.d
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgserver.conf --insecure > /etc/dnsmasq.d/fgserver.conf
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgset.conf --insecure > /etc/dnsmasq.d/fgset.conf

#config firewall
cp -f /etc/firewall.user /etc/firewall.user.back
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
echo "           Now, you can visit Google, Youtube, etc.          "
echo ""
echo "                            Notice                           "
echo ""
echo " Don't forget to run reinstall.sh after update the MiRouter! "
echo ""
echo "-------------------------------------------------------------"
echo ""
exit 0
