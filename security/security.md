# Security 网络安全

## Kali 网络配置

实用Kali虚拟机需要开启桥接模式。
修改`/etc/network/interfaces`文件

dhcp 自动获取ip地址
```
auto eth0
iface eth0 dhcp
```

手动IP设置
```
auto eth0
iface eth0 inet static
address 192.168.10.188
netmask 255.255.255.0
gateway 192.168.10.1
```

重启网络服务

```sh
/etc/init.d/networking restart
```

## Nmap 常用指令

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

## 网络中图片嗅探
driftnet [options] [filter code]

```
主要参数：

-b 捕获到新的图片时发出嘟嘟声

-i interface 选择监听接口

-f file 读取一个指定pcap数据包中的图片

-p 不让所监听的接口使用混杂模式

-a 后台模式：将捕获的图片保存到目录中（不会显示在屏幕上）

-m number 指定保存图片数的数目

-d directory 指定保存图片的路径

-x prefix 指定保存图片的前缀名

使用举例：

1.实时监听： driftnet -i wlan0

2.读取一个指定pcap数据包中的图片： driftnet -f /home/linger/backup/ap.pcapng -a -d /root/drifnet/

```
