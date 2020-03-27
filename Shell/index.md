# Shell 命令收集

* [定时任务crontab](crontab.md)
* [命令行分屏screen](screen.md)
* [tldr命令手册](tldr.md)
* [root权限用户](root.md)

## java 环境变量配置

编辑profile文件
```
vi /etc/profile
```
添加环境变量
```
JAVA_HOME=/opt/jdk1.8.0_152   #jdk存放位置     
JRE_HOME=/opt/jdk1.8.0_152/jre    #jre存放位置 
PATH=$PATH:$JRE_HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export JRE_HOME
export PATH
```
编译profile文件
```
source /etc/profile
```
测试一下
```
java -version 
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