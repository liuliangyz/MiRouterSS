#!/bin/sh

clear
echo "-------------------------------------------------------------"
echo ""
echo "              Install Shadowsocks For Miwifi                 "
echo ""
echo "                     MiRouterSS v0.1                         "
echo ""
echo "-------------------------------------------------------------"

# Make sure Shadowsocks has not been installed
if [[ -f /etc/firewall.user.back ]]; then
  echo "Error: You have installed Shadowsocks." 1>&2
  exit 1
fi

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
   echo "Error: This script must be run as root!" 1>&2
   exit 1
fi

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
mkdir -p /etc/shadowsocks
echo "-------------------------------------------------------------"
echo ""
echo "        Please input your shadowsocks configuration          "
echo ""
echo "-------------------------------------------------------------"
echo ""
echo "input server_address(IP address is suggested):"
read serverip
echo "input server_port:"
read serverport
echo "input local_port(1082 is suggested):"
read localport
echo "input password:"
read shadowsockspwd
echo "input method (Such as aes-256-cfb, rc4-md5, etc.)"
read method

# Save ShadowSocks Settings
cat > /etc/shadowsocks/config.json<<-EOF
{
    "server":"${serverip}",
    "server_port":${serverport},
    "local_port":${localport},
    "password":"${shadowsockspwd}",
    "timeout":60,
    "method":"${method}"
}
EOF

# Backup ShadowSocks Settings
cp -f /etc/shadowsocks/config.json /userdisk/data/MiRouterSS/Backup/config.json

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
echo "       Congratulations, MiRouterSS installed complete!       "
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
