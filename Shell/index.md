# Shell 

* [定时任务crontab](crontab.md)
* [命令行分屏screen](screen.md)
* [tldr命令手册](tldr.md)
* [root权限用户](root.md)

## 测试连接远程主机端口

``` sh
ssh -v -p 80 username@10.0.250.3
```

-v 调试模式(会打印日志).

-p 指定端口

username 可以随意

失败: ssh: connect to host 10.0.250.3 port 80: Connection refused

成功: debug: Connection established.

## omyzsh 安装

### 安装zsh

```
apt install zsh
```
### 安装git
```
apt install zsh
```
### 安装ohmyzsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 配置主题
```
vi ~/.zshrc
```
修改 ZSH_THEME="agnoster" # 这是最花哨的一个

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
