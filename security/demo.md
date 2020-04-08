# 漏洞利用

## CVE-2020-1938 文件包含漏洞

### 漏洞说明
该漏洞是由于Tomcat AJP协议存在缺陷而导致，攻击者利用该漏洞可通过构造特定参数，读取服务器webapp下的任意文件。若目标服务器同时存在文件上传功能，攻击者可进一步实现远程代码执行。目前，厂商已发布新版本完成漏洞修复。

受影响版本

* Apache Tomcat 6  
* Apache Tomcat 7 < 7.0.100  
* Apache Tomcat 8 < 8.5.51
* Apache Tomcat 9 < 9.0.31

不受影响版本

* Apache Tomcat = 7.0.100
* Apache Tomcat = 8.5.51
* Apache Tomcat = 9.0.31

### PoC
github: <https://github.com/yangb92/AJPy>
