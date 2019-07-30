# Spring Cloud 上下文
Spring Boot 有一套自己的方式构建一个Spring 应用程序，例如有公共配置文件的常规位置，以及用于程序管理和见识任务的端点。Spring Cloud 在 Spring Boot 的基础上增加了一些通用的功能。

## 引导上下文
Spring Cloud 通过创建“引导”的上下文来运行，它是主程序的父上下文,它负责从外部加载配置属性，并揭秘本地外部配置文件中的属性。这两个上下文共享一个`Environment`(环境),该环境是Spring应用程序的外部属性来源。默认情况下，引导属性的优先级高，因此它不能被本地配置覆盖。

引导上下文和主程序的上下文使用不同的外部配置，可以使用 bootstrap.yml 代替application.yml 使引导上下文和主程序上下文保持完全的分离。
例如: 

**bootstrap.yml* *
```yml
spring:
  application:
    name: foo
  cloud:
    config:
      uri: ${SPRING_CONFIG_URI:http://localhost:8888}
```
如果你需要来自服务器任何特定的配置，需要设置`spring.application.name`, 该属性作为应用程序的ID。

也能够通过`spring.cloud.bootstrap.enabled=false`属性关闭引导的加载。

## 程序的上下文层次结构
如果你从 SpringApplication 或者 SpringApplicationBuilder， 引导上下文作为改上下文的父级添加。Spring的一个特性是子上下文从父级继承属性源和配置文件, 因此主应用程序上下文包含额外的属性源。与没有用Spring Cloud配置构建的上下文相比，额外的属性源是：
    * 如果 PropertySourceLocators 在引导上下文中存在，并且属性不为空，一个可选的CompositePropertySource以高优先级出现
