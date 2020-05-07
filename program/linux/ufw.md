# UFW 防火墙管理

教程: https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-18-04/

切记: UFW必须先配置把ssh端口配进去,再开启, 不然连不上服务器就没办法了

## Install UFW

```sh
sudo apt install ufw
```

## Check UFW Status

```
sudo ufw status verbose
```

使用apt命令安装软件包时，它将在/etc/ufw/applications.d目录中添加应用程序配置文件。 该配置文件描述了服务并包含UFW设置。

## 开放端口

```
ufw allow 4422/tcp
```