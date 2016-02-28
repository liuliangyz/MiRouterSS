#MiRouterSS
More easier to use ShadowSocks on your MiRouter.

Ps: This project is based on the bazingaterry/ShadowsocksForMiRouter(Github) and adds useful scripts.

Author: Jacky

##**Include**
1. Install/Unistall/Reinstall script
2. ShadowSocks For MiRouter
3. Some DNS lists

##**Requirements:**
1. MiRouter >= R1D (MiRouterSS doesn't support MiRouter Mini)
2. Your MiRouter has already open SSH
3. You have ShadowSocks server account
Such as
>"server":"${serverip}",
>"server_port":${serverport},
>"local_port":${localport},
>"password":"${shadowsockspwd}",
>"timeout":60,
>"method":"${method}"

##**How to install it**
1. SSH to your MiRouterSS
2. Enter the userdisk directory
```
cd /userdisk/data/
```
3. Install MiRouterSS
```
wget http://cdn.jackyu.cn/download/MiRouterSS.tar.gz && tar dxf MiRouterSS.tar.gz && cd MiRouterSS && chmod +x *.sh && sh install.sh
```

##**Tips**
1. Uninstall MiRouterSS
```
cd /userdisk/data/MiRouterSS/ && sh uninstall.sh
```
2. After you update MiRouter's system, please run
```
cd /userdisk/data/MiRouterSS/ && sh reinstall.sh
```
3. Common commands
```
/etc/init.d/dnsmasq restart （Restart dnsmasq)
/etc/init.d/firewall restart （Restart firewall)
/etc/init.d/shadowsocks start/stop (Start/Stop ShadowScoks)
/etc/init.d/shadowsocks enable/disable (Enable/Disable Boot)
```
##Special thanks to
bazingaterry/ShadowsocksForMiRouter (Github)
