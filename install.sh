#!/bin/sh

Ver='1.0'

clear
echo "-------------------------------------------------------------"
echo ""
echo "              Install Shadowsocks For MiRouter               "
echo ""
echo "              MiRouterSS v${Ver} Written by Jacky            "
echo ""
echo "-------------------------------------------------------------"

# Make sure Shadowsocks has not been installed
if [[ -f /etc/firewall.user.bak ]]; then
  echo "Error: You have installed Shadowsocks." 1>&2
  exit 1
fi

# Make sure only root can run our script
if [[ `id -u` -ne 0 ]]; then
 echo "Error: This script must be run as root!" 1>&2
 exit 1
fi

#Install
read -p "Do you want to install MiRouterSS ？ (y/N)" install
if [[ "$install" = "y" ]]; then
cd /userdisk/data/
if [[ -f MiRouterSS.tar.gz ]]; then
  rm -f MiRouterSS.tar.gz && rm -f MiRouterSS
fi
wget http://dl.jackyu.cn/attachments/MiRouterSS/MiRouterSS.tar.gz
tar zxf MiRouterSS.tar.gz
mkdir -p ./MiRouterSS/Backup

# Install shadowsocks ss-redir to /usr/bin
mount / -o rw,remount
cp -f ./MiRouterSS/ss-redir  /usr/bin/ss-redir
chmod +x /usr/bin/ss-redir
sync

# Config shadowsocks init script
cp ./MiRouterSS/shadowsocks /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks

# Config ShadowSocks setting
read -p "Do you want to create configuration file? (y/N)" createConfig
if [[ "$createConfig" = "y" ]]; then
  mkdir -p /etc/shadowsocks
  echo "-------------------------------------------------------------"
  echo ""
  echo "        Please input your shadowsocks configuration          "
  echo ""
  echo "-------------------------------------------------------------"
  echo ""
  echo "Please input server_address(IP):"
  read serverip
  echo "Please input server_port:"
  read serverport
  echo "Please input local_port(1082 is suggested):"
  read localport
  echo "Please input server_password:"
  read shadowsockspwd
  echo "Please input method (Such as aes-256-cfb, rc4-md5, etc.)"
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
fi
# Config dnsmasq
mkdir -p /etc/dnsmasq.d
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgserver.conf --insecure > /etc/dnsmasq.d/fgserver.conf
curl https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/fgset.conf --insecure > /etc/dnsmasq.d/fgset.conf

# Config firewall
cp -f /etc/firewall.user /etc/firewall.user.bak
echo "ipset -N setmefree iphash -! " >> /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp -m set --match-set setmefree dst -j REDIRECT --to-port ${localport}" >> /etc/firewall.user

# Restart all service
/etc/init.d/dnsmasq restart
/etc/init.d/firewall restart
/etc/init.d/shadowsocks start
/etc/init.d/shadowsocks enable

# Backup ShadowSocks Settings
cp -f /etc/shadowsocks/config.json /userdisk/data/MiRouterSS/Backup/config.json

# Install successfully
rm -rf /userdisk/data/MiRouterSS.tar.gz
rm -rf /userdisk/data/install.sh
mount / -o ro,remount

echo "-------------------------------------------------------------"
echo ""
echo ""
echo "       Congratulations, MiRouterSS installed complete!       "
echo ""
echo "      For more information please visit https://jackyu.cn    "
echo ""
echo ""
echo "-------------------------------------------------------------"
echo ""
fi
exit 0
