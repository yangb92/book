# java 环境变量配置

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