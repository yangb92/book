# Linux 服务化部署

官方文档: 

<https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/html/deployment.html#deployment-install>



## 配置Maven插件

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <executable>true</executable>
    </configuration>
</plugin>
```



## 安装为init.d服务

假设你的SpringBoot程序部署在/var/myapp路径，要将SpringBoot程序作为init.d服务，需要创建一个软链接，如下:

```sh
$ sudo ln -s /var/myapp/myapp.jar /etc/init.d/myapp
```

安装后，就可以按系统服务的方式启动和停止。例如，在基于debian的系统上，可以使用以下命令启动它:

```sh
$ service myapp start
```

日志在/var/log/myapp.log中可以查看.



## FQ

### spring boot 在Linux下服务启动报错Unable to find Java

将java 连接到/sbin 文件夹下

```sh
ln -s /usr/local/jdk/bin/java /sbin/java
```