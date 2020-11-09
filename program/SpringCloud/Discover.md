# 服务注册与发现

## Eureka

#### 服务端

1. 建model
2. 改POM
3. 写YML
4. 主启动
5. 业务类

##### POM

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>microservice</artifactId>
        <groupId>com.yangb</groupId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>serve-discover</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <fork>true</fork>
                    <addResources>true</addResources>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

##### application.yml

```yml
server:
  port: 35001

eureka:
  instance:
    hostname: localhost
  client:
    register-with-eureka: false # 不向注册中心注册自己
    fetch-registry: false # 注册中心不需要去检索服务
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/ # 服务地址
```

##### 主启动类

```java
/**
 * Created by yangb on 2020/4/22
 * Copyright (c) 2020 杨斌 All rights reserved.
 */
@SpringBootApplication
@EnableEurekaServer
public class DiscoverServer {
    public static void main(String[] args) {
        SpringApplication.run(DiscoverServer.class, args);
    }
}
```

访问<http://localhost:35001/>

#### 客户端

##### POM

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

##### application.yml

```yml
# 服务注册
eureka:
  client:
    service-url:
      defaultZone: http://localhost:35001/eureka
```

在最新版本的Eurika,不需要在主启动类添加@EnableEurekaClient注解来开启了, 引入依赖自动注册服务

### 注册中心集群

互相注册,相互守望

#### 修改系统hosts文件

```hosts
127.0.0.1 eureka35001.com
127.0.0.1 eureka35002.com
```

#### 服务端

##### application.yml

35001 服务

```yml
server:
  port: 35001

eureka:
  instance:
    hostname: eureka35001.com
  client:
    register-with-eureka: false # 不向注册中心注册自己
    fetch-registry: false # 注册中心不需要去检索服务
    service-url:
      defaultZone: http://eureka35002:35002/eureka/ # 服务地址
```

35002 服务

```yml
server:
  port: 35002

eureka:
  instance:
    hostname: eureka35002.com
  client:
    register-with-eureka: false # 不向注册中心注册自己
    fetch-registry: false # 注册中心不需要去检索服务
    service-url:
      defaultZone: http://eureka35001:35001/eureka/ # 服务地址
```

#### 客户端

##### application.yml

```yml
# 服务注册
eureka:
  client:
    service-url:
      defaultZone: http://eureka35001:35001/eureka,http://eureka35002:35002/eureka
  # 这里不一定要配置,因为默认提供的已经够用了
  instance:
    instance-id: ${spring.application.name}:${server.port} # 实例信息
    prefer-ip-address: true # 带实例IP地址
```

> 这里如果不改hosts文件, 所有地址使用默认的localhost也没有问题

### Eureka自我保护机制

```
EMERGENCY! EUREKA MAY BE INCORRECTLY CLAIMING INSTANCES ARE UP WHEN THEY'RE NOT. RENEWALS ARE LESSER THAN THRESHOLD AND HENCE THE INSTANCES ARE NOT BEING EXPIRED JUST TO BE SAFE.
```

如果我们在Eureka Server看到了这段提示, 说明Eureka进入了保护模式

#### 原因

某时刻一个微服务不可用了,Eureka不会立刻清理,依旧会对该微服务的信息保存.

#### 什么是自我保护

默认情况下, 如果Eureka在一定时间内没有接收到某个微服务实例的心跳, EurekaServer将会注销该实例(默认90s)

属于CAP里面的AP分支设计思想: 好死不如赖活着的设计哲学

#### 关闭自我保护

##### 服务端

```yml
eureka:
  server:
    enable-self-preservation: false # 关闭自我保护
    eviction-interval-timer-in-ms: 3000 # 如果超过3秒收不到心跳,剔除此服务
```

##### 客户端

```yml
eureka:
  instance:
    lease-renewal-interval-in-seconds: 30 # Eureka 客户端向服务端发送心跳的时间间隔
    lease-expiration-duration-in-seconds: 90 # Eureka服务端在收到最后一次心跳后等待的时间上限, 超时将剔除服务
```





**DiscoverClient** 

```java
@Autowired
private DiscoveryClient discoveryClient;
String clients = discoveryClient.getServices().stream()
    .map(item -> discoveryClient.getInstances(item).stream()
         .map(instance ->
              instance.getHost() +  instance.getPort() + instance.getUri() + 			instance.getScheme()
             ).collect(Collectors.joining("|")))
    .collect(Collectors.joining("/"));
```

