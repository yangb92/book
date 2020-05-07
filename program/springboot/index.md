# Spring Boot

## 项目结构

### 定位程序主类

默认推荐将启动类放在根目录中，高于其他的类。 @SpringBootApplication 注解放在主类上面，它还隐式的定义基础的所要扫描的包。

> 如果你不想用@SpringBootApplication， 可以使用@EnableAutoConfiguration 和 @ComponentScan 注解来定义这些。

典型的布局结构

```
com
 +- example
     +- myapplication
         +- Application.java
         |
         +- customer
         |   +- Customer.java
         |   +- CustomerController.java
         |   +- CustomerService.java
         |   +- CustomerRepository.java
         |
         +- order
             +- Order.java
             +- OrderController.java
             +- OrderService.java
             +- OrderRepository.java
```



## 配置类

Spring Boot 支持 java类配置和xml同事配置， 在配置类使用一个@Configuration， 通常定义 main 方法的主类很适合使用@Configuration。

### 导入其他配置类

你不需要将所有的@Configuration放入一个类中， @Import 注解能够用来加入配置类，或者，您可以使用@ComponentScan自动获取所有包括 @Configuration 类的Spring组件

### 导入XML配置

如果你必须要使用xml配置，我们建议您仍然从@Configuration类开始，你可以使用一个@ImportResource 注解加载xml配置文件。



## 自动配置

### 禁用特定的自动配置类

您可以使用@EnableAutoConfiguration的exclude属性禁用它们，如下面的示例所示:

```java
import org.springframework.boot.autoconfigure.*;
import org.springframework.boot.autoconfigure.jdbc.*;
import org.springframework.context.annotation.*;
@Configuration
@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})
	public class MyConfiguration {
}

```



## Spring Bean 和 依赖注入

您可以自由地使用任何标准Spring框架技术来定义bean及其注入的依赖项。为了简单起见，我们经常发现使用@ComponentScan(查找bean)和使用@Autowired(执行构造函数注入)工作得很好。

如果按照上面的建议构造代码(将应用程序类定位在根包中)，可以添加@ComponentScan，而不需要任何参数。所有应用程序组件(@Component、@Service、@Repository、@Controller等)都自动注册为Spring bean。

> 注意使用构造注入的bean 使用final 防止被更改。

## 使用@SpringBootApplication注解

使用一个@SpringBootApplication注释来启用这三个特性，即:

 @EnableAutoConfiguration: enable Spring Boot’s auto-configuration mechanism
• @ComponentScan: enable @Component scan on the package where the application is located (see the best practices)
• @Configuration: allow to register extra beans in the context or import additional configuration classes

@SpringBootApplication还提供别名来定制@EnableAutoConfiguration和@ComponentScan的属性

这些特性都不是强制性的，您可以选择用它支持的任何特性替换这个注释。例如，你可能不想在你的应用程序中使用组件扫描:

```java
package com.example.myapplication;
import org.springframework.boot.SpringApplication;
import org.springframework.context.annotation.ComponentScan
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
@Configuration
@EnableAutoConfiguration
@Import({ MyConfig.class, MyAnotherConfig.class })
public class Application {
 public static void main(String[] args) {
   SpringApplication.run(Application.class, args);
 }
}
```



## 开发工具

添加开发依赖

```xml
<dependencies>
 <dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-devtools</artifactId>
  <optional>true</optional>
 </dependency>
</dependencies
```

开发依赖将在打包时关闭，并且用java -jar 运行时认为是生产环境，会自动关闭。 若要手动关闭，请设置Dspring.devtools.restart.enabled=false 属性

### 自动重启

类路径上的文件发生更改，将会自动重启，静态资源或模板发生更改，不会重启，

> 触发自动重启的唯一方法是更新类路径， Eclipse 自动更新， ide需要build

### 排除一些资源变动，不重启

spring.devtools.restart.exclude=static/**,public/**

远程开发

需要添加插件

```xml
<build>
 <plugins>
  <plugin>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-maven-plugin</artifactId>
   <configuration>
    <excludeDevtools>false</excludeDevtools>
   </configuration>
  </plugin>
 </plugins>
</build>

```

然后需要设置spring.devtools.remote.secret属性，如下面的示例所示:

```properties
spring.devtools.remote.secret=mysecret
```

存在安全风险，不建议用在生产服务器上。

远程开发工具由两部分提供支持，接受连接的服务器端端点和在IDE中运行的客户机应用程序。当设置spring.devtools.remote.secret属性时，服务器组件将自动启用。客户端组件必须手动启动。

### jar包部署至远程服务器

* 在服务器上运行jar包，address=5005 是调试端口

```bash
java -jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 demo-0.0.1-SNAPSHOT.jar
```

* IDE 上开启远程调试

只需要输入主机地址和调试端口即可热更新和调试，实现本地开发，远程运行，降低对开发电脑的资源占用。



### 运行远程客户端程序

远程客户端程序被设计运行在IDE，您需要运行org.springframework.boot.devtools.RemoteSpringApplication，其类路径与您连接到的远程项目相同，应用程序唯一需要的参数是它连接到的远程URL。

