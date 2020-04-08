# 创建root权限用户

```sh
# 创建用户
adduser tomcat
# 设置密码
passwd tomcat
# 赋予root权限
vim /etc/sudoers
# 文件下面添加如下内容
-----------
# User privilege specification
root    ALL=(ALL:ALL) ALL
tomcat  ALL=(ALL:ALL) ALL

```