# SpringBoot 整合 tk.mybatis

## 引入依赖

在`pom.xml`引入依赖,该依赖会自动引入MyBaits依赖

```xml
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper-spring-boot-starter</artifactId>
    <version>2.0.2</version>
</dependency>
```

## 配置 application.yml

配置 MyBatis

```yml
mybatis:
    type-aliases-package: 实体类的存放路径，如：com.funtl.hello.spring.boot.entity
    mapper-locations: classpath:mapper/*.xml
```

## 创建一个通用的父级接口

主要作用是让 DAO 层的接口继承该接口，以达到使用 tk.mybatis 的目的

```java
package com.funtl.utils;

import tk.mybatis.mapper.common.Mapper;
import tk.mybatis.mapper.common.MySqlMapper;

/**
 * 自己的 Mapper
 * 特别注意，该接口不能被扫描到，否则会出错
 * <p>Title: MyMapper</p>
 * <p>Description: </p>
 *
 * @author Lusifer
 * @version 1.0.0
 * @date 2018/5/29 0:57
 */
public interface MyMapper<T> extends Mapper<T>, MySqlMapper<T> {
}
```