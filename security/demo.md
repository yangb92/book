# 漏洞利用

## Shiro RememberMe 反序列化漏洞

Apache Shiro 在 Java 的权限及安全验证框架中占用重要的一席之地，在它编号为550的 issue 中爆出严重的 Java 反序列化漏洞。

影响版本: 

Shiro 1.2.4

参考文章: 

* https://paper.seebug.org/shiro-rememberme-1-2-4/
* https://blog.knownsec.com/2016/08/apache-shiro-java/

## Tomcat AJP 任意文件读取 CVE-2020-1938

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


## ThinkPhp 5.x 漏洞

POC: https://github.com/SkyBlueEternal/thinkphp-RCE-POC-Collection

## FastJson 反序列化漏洞

Payload: https://github.com/OneSourceCat/BcelPayloadGenerator