# Spring Cloud 工程搭建

源码: https://github.com/yangb92/spring-cloud-yoyo

## 环境准备

> 约定 > 配置 > 编码

### 工程结构

```
project
--module
```

### Maven

Maven 选择3.5.2以上

开启跳过maven单元测试 skip test 

### 字符编码

settings - Editor - File Encodings:

```
Global Encoding UTF-8
Project Encoding UTF-8
Default encoding for properties files: UTF-8
```

### 注解激活生效

```
setting-build-compiler-Annotation Processors 打钩 Enable annotation processing
```

### Java编译版本

```
setting-build-compiler-Java Compiler 选择java版本8
```

### File Type 过滤

settings - Editor - File Types 添加不需要显示的文件

## 父工程 (聚合模块)

### 项目创建 

创建标准maven项目, 项目下面只保留pom文件.

### pom文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.5.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.yangb</groupId>
    <artifactId>microservice</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>pom</packaging>
    <name>microservice</name>
    <description>微服务框架 http://book.yangb.xyz</description>

    <!--统一版本管理-->
    <properties>
        <!--boot/cloud/cloud alibaba 版本依赖关系请参考 http://book.yangb.xyz-->
        <spring-boot.version>2.2.5.RELEASE</spring-boot.version>
        <spring-cloud.version>Hoxton.SR3</spring-cloud.version>
        <spring-cloud-alibaba.version>2.2.1.RELEASE</spring-cloud-alibaba.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <junit.version>4.12</junit.version>
        <log4j.version>1.2.17</log4j.version>
        <lombok.version>1.16.18</lombok.version>
        <mysql.version>5.1.47</mysql.version>
        <druid.version>1.1.16</druid.version>
        <mybatis.spring.boot.version>1.3.0</mybatis.spring.boot.version>
    </properties>

    <!-- 规定子项目依赖版本号 (仅仅指定版本号,并不引入依赖) -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring-cloud-alibaba.version}</version>
            </dependency>
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql.version}</version>
            </dependency>
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid</artifactId>
                <version>${druid.version}</version>
            </dependency>
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis.spring.boot.version}</version>
            </dependency>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>${junit.version}</version>
            </dependency>
            <dependency>
                <groupId>log4j</groupId>
                <artifactId>log4j</artifactId>
                <version>${log4j.version}</version>
            </dependency>
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
                <optional>true</optional>
            </dependency>
        </dependencies>
    </dependencyManagement>

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



## 业务模块

微服务模块步骤:

1. 建model
2. 改POM
3. 写YML
4. 主启动
5. 业务类

例如: 支付模块

### pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>microservice</artifactId>
        <groupId>com.yangb</groupId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>business-payment</artifactId>
    <packaging>jar</packaging>
    <description>业务模块 - 支付</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.1.10</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>

```

### application.yml

```yml
server:
  port: 8001

spring:
  application:
    name: payment-service
  datasource:
    druid:
      url: jdbc:mysql://localhost:3306/quick_db?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC
      username: root
      password: root
      initial-size: 1
      min-idle: 1
      max-active: 20
      test-on-borrow: true
      # driver-class-name: com.mysql.jdbc.Driver
      driver-class-name: com.mysql.cj.jdbc.Driver # MySql8.x

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.yangb.business.payment.entity

```

### 主启动

```java
/**
 * Created by YangBin on 2020/4/22
 * Copyright (c) 2020 杨斌. All rights reserved.
 */
@SpringBootApplication
public class PaymentServer {
    public static void main(String[] args) {
        SpringApplication.run(PaymentServer.class, args);
    }
}
```

### 整合Spring Boot 单体应用快速开发框架

<https://github.com/yangb92/SpringBootQuickDevlop>

授权模块我们最后使用OAuth2.0统一认证, 先不进行整合. 可参考本文档SpringBoot章节

| 模块名称   | 描述                                |
| ---------- | ----------------------------------- |
| tk.mybatis | 使用tk.mybatis框架,简化数据库操作。 |
| PageHelper | 分页插件                            |
| generator  | 自动生成Entity,Mapper和Dao          |

## 注册中心

见文档 [服务发现](Discover.md)

## 负载均衡

见文档 [负载均衡](loadbalance.md)

## 服务调用

见文档 [服务调用](ServiceCall.md)

## 服务降级

参考文档[Hystrix](Hystrix.md)

## 服务网关

参考文档[服务网关](gateway.md)