# Spring Cloud 上下文
Spring Boot 有一套自己的方式构建一个Spring 应用程序，例如有常规的公共配置文件位置，以及用于程序管理和监视任务的端点。Spring Cloud 在 Spring Boot 的基础上增加了一些通用的功能。

## 引导上下文
Spring Cloud 通过创建“引导”的上下文来运行，它是主程序的父上下文,它负责从外部加载配置属性，并解密本地外部配置文件中的属性。这两个上下文共享一个`Environment`(环境),该环境是Spring应用程序的外部属性来源。默认情况下，引导属性的优先级高，因此它不能被本地配置覆盖。

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
引导上下文是作为父上下文添加到程序的上下文中，子上下文从父上下文中继承属性

* 由于属性源的排序规则，引导项优先。但是，请注意，这些文件不包含来自引导程序的任何数据。它的优先级非常低，但是可以用来设置默认值。
* 常规Spring应用程序上下文行为规则适用于属性解析:来自子上下文的属性通过名称和属性源名称覆盖父上下文中的属性

## 修改引导文件的位置
bootstrap.yml(或 .properties)位置可由`spring.cloud.bootstrap.name`(默认: bootstrap) 或者 `spring.cloud.bootstrap.location`(默认:空)指定。

## 重写远程属性的值
通过引导上下文添加到应用程序中的属性通常是远程的。(例: Spring Cloud Config Server),默认情况下,不能再本地重写他们，如果你想让程序自己的系统属性或配置文件覆盖远程属性,远程属性源必须通过设置授予它权限`spring.cloud.config.allowOverride=true`(在本地设置是无效的)一旦设置该标志后，两个更细粒度的设置将控制远程属性相对于系统属性和应用程序本地配置的位置
* `spring.cloud.config.overrideNone=true` 允许任何本地属性源进行覆盖。
* `spring.cloud.config.overrideSystemProperties=false` 只有系统属性，命令行参数和环境变量(而不是本地配置文件)才能够覆盖远程设置。

## 自定义引导配置
引导上下文可以通过在名为`org.springframework.cloud.bootstrap.BootstrapConfiguration` 的键下向 `/META-INF/spring.factories` 添加条目来设置您喜欢的任何操作。它包含一个以逗号分隔的Spring @Configuration类列表，用于创建上下文，您可以在此处创建您希望可用于主应用程序上下文以进行自动装配的任何Bean。



## 自定义引导属性源

 引导过程添加的外部配置的默认属性源是 Spring Cloud Config Server,但是您可以通过向引导上下文(通过spring.factories)添加PropertySourceLocator类型的bean来添加额外的源,例如，你可以从数据库添加扩展属性。

如：

```java
@Configuration
public class CustomPropertySourceLocator implements PropertySourceLocator {

    @Override
    public PropertySource<?> locate(Environment environment) {
        return new MapPropertySource("customProperty",
                Collections.<String, Object>singletonMap("property.from.sample.custom.source", "worked as intended"));
    }

}
```

传入的 Environment 是即将创建ApplicationContext的环境，换句话说，我们为它提供额外的属性源，它已经有了Spring Boot 提供的属性源，因此，您可以使用它们来查找特定与此环境的属性源。

如果你创建了一个包含此类的jar，然后添加到 META-INF/spring.factories

```properties
org.springframework.cloud.bootstrap.BootstrapConfiguration=sample.custom.CustomPropertySourceLocator
```

## 日志配置

如果您打算使用SpringBoot 来配置日志，那么应该将配置放在bootstrap.yml 中，

## 环境变化

当配置发生变化后，如何加载新的配置信息？

程序侦听`EnvironmentChangeEvent` 的事件(观察者设计模式)，有一个已更改的键值列表，应用程序将会：

* 重新绑定任何`@ConfigurationProperties`Bean的上下文。
* 设置`logging.level.*`日志级别的任何属性。

注意，默认情况下客户端不会轮询环境变量发生变化，通常，我们不建议使用这种方法来检测更改(尽管你可以使用`@Scheduled`定时注解) 如果你有一个扩展的客户机程序，最好的办法是发送`EnvironmentChangeEvent`广播给所有的实例，而不是让轮询更改，(例如：使用  [Spring Cloud Bus](https://github.com/spring-cloud/spring-cloud-bus) Spring Cloud 云总线)

## 刷新范围

-