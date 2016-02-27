# MiRouterSS #
--------------------
More easier to install ShadowSocks on your MiRouter.

## What is ShadowSocks
--------------------
ShadowSocks is a tool that can help you to visit Google, Youtube, etc. But before you install it make sure that you have ShadowSocks server configuration.

If you want to know more about ShadowSocks, please search it on Google

##Requirements:
**Minimum:**

1. MiRouter >= R1D (MiRouterSS doesn't support MiRouter Mini)
2. MiRouter System Version >= 2.0
3. Your MiRouter has already open SSH

**ShadowSocks server configuration**

Such as

>    "server":"${serverip}",

>    "server_port":${serverport},

>    "local_port":${localport},

>    "password":"${shadowsockspwd}",

>    "timeout":60,

>    "method":"${method}"

## MiRouterSS include
-----------------------
+ Install/Unistall/Reinstall script
+ ShadowSocks For MiRouter
+ Some DNS list

## How to install it
-----------------------

#### 1. SSH to your MiRouter.

#### 2. Enter the userdisk directory
```
cd /userdisk/data/
```
#### 3. Download MiRouterSS
```
wget https://raw.githubusercontent.com/Jackyxyz/MiRouterSS/master/MiRouter0.1.tar.gz && MiRouter0.1.tar.gz && cd MiRouter0.1
```
#### 4. Give permission to scripts
```
chmod +x *.sh
```
#### 5. Run install shell script
```
sh install.sh
```

## Tips
---------------
If you want to unistall Shadowsocks, please run uninstall.sh.

After updata the MiRouter system please run reinstall.sh.

##Special thanks to
---------------
bazingaterry/ShadowsocksForMiRouter
