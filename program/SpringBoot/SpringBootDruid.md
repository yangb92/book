# SpringBoot 整合 Druid

## 引入依赖

在pom文件引入druid依赖

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.22</version>
</dependency>
```

引入数据库连接依赖

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>
```

## 配置application.yml
```yml
spring:
  datasource:
    druid:
      url: jdbc:mysql://ip:port/dbname?useUnicode=true&characterEncoding=utf-8&useSSL=false
      username: root
      password: 123456
      initial-size: 1
      min-idle: 1
      max-active: 20
      test-on-borrow: true
      # MySQL 8.x: com.mysql.cj.jdbc.Driver
      driver-class-name: com.mysql.jdbc.Driver
```
