# Security 网络安全

## 科学上网服务建设

使用V2Ray 

https://github.com/233boy/v2ray/wiki/V2Ray%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%AC

v2ray url 可生成 vmess URL 链接

## 国外VPS服务器

https://bwh88.net/  境外服务器不易受到监管

## 家用智能设备攻击思路

破解家用路由器或者控制一台肉鸡, 在内网扫描支持UPnP协议的只能设备, 使用UPnP利用工具miranda进行扫描和利用

### UPnP 协议

UPnP为即插即用的缩写（Universal Plug and Play）是一套网络协议。适用于家庭网络，用于设备间的发现和连接。希望实现任何设备只要一接入网络就能被网络中的所有其它设备发现，做到完全的即插即用。

### miranda 
Miranda是Kali提供的一款基于Python语言的UPNP客户端工具。它可以用来发现、查询和操作UPNP设备，尤其是网关设置。

* pcap：被动发现设备通过嗅探设备接入网络时发送的NOTIFY消息获取设备信息。
* msearch:通过主动发送M-serach消息来发现设备。（一般使用msearch比较快）

发现设备后可用host命令来查看详细信息。
```
host list：查看发现的设备列表
host get <n>：获取信息（查询summary之前需执行）
host info <n>：显示查询到的信息
host summary 0 ：显示xml文件的摘要信息
（n为设备在列表中的编号）
```

获取设备列表
```
host info 0 deviceList
```
获取设备支持的命令/服务信息（命令很长使用Tab键补齐很方便 ）
```
host info 0 deviceList WANConnectionDevice services WANIPConnection actions
```


## TCP 三次握手

* SYN: synchronous 同步
* ACK: acknowledgement 确认

1. client --SYN--> server
2. server --ACK+SYN--> client
3. client --ACK--> server

## Nmap 常用指令

主机发现:
```
-sn Tcp ping扫描
-Pn 跳过主机发现
-PS/PA/PU/PY[portlist]: SYN/ACK/UDP/SCTP
-n: 不做反向DNS查询
--dns-servers 8.8.8.8 : 指定dns服务器
-p-: 扫描所有端口
```

快速扫描主机的详细信息
```sh
nmap -sT -sV -Pn -v xxx.xxx.xxx.xxx
```

扫描所有的端口开放情况
```sh
nmap -sS -p 1-65535 -v 192.168.1.254
```

扫描网段主机(ping扫描)
```sh
nmap -sn 192.168.16.100-150
```

深度扫描网络主机信息
```sh
nmap -A -T4 192.168.10.1
```

半开扫描(TCP SYN扫描) - 隐秘且速度快，比较常用
```sh
nmap -sS host
```

## Robots 扫描工具 parsero
扫描robots目录的地址
```
parsero -u url

-o 只显示连接成功的
-sb 使用bing搜索引擎查找robots文件.
```