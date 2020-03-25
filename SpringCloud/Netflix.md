# Netflix

该项目为Spring Boot 程序提供Netflix OSS集成, 通过简单的注释,您可以在应用程序中快速启用经过实战考验的Netflix组建构建大型分布式系统.提供的模式包括服务发现(Eureka) 断路器(Hystrix) 智能路由(Zuul)和客户端负载均衡(Ribbon)



## 1. 服务发现-Eureka Client

服务发现是微服务架构的关键点, Eureka是Netflix服务发现的 服务端和客户端, 可以将服务配置和部署为高可用性,每个服务将注册服务的状态复制到其他服务器.



### 1.1 怎样引入Eureka Client

在项目中引入Eureka Client, 使用 starter, group Id  `org.springframework.cloud` ,artifact ID  `spring-cloud-starter-netflix-eureka-client`.

### 1.2 Eureka 注册

当一个Eureka客户端注册, 它提供关于自身的元数据,类如 主机,端口,健康端点URL, 主页和其他详细信息, Eureka 接收每个实例的心跳消息, 如果心跳超过配置的时间,该实例通常从注册表中删除.

下面的例子时一个最小的Eureka客户端程序.

```java
@SpringBootApplication
@RestController
public class Application {

    @RequestMapping("/")
    public String home() {
        return "Hello world";
    }

    public static void main(String[] args) {
        new SpringApplicationBuilder(Application.class).web(true).run(args);
    }

}
```

注意,上面的程序时一个普通的Spring Boot程序, 当classpath 加入 spring-cloud-starter-netflix-eureka-client 时, 你的应用程序会自动注册到Eureka Server

需要配置来定位Eureka服务器, 如下所示:

```yaml
eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka/
```

在上面的例子中, defaultZone 是一个神奇的后备字符串,它为任何没有表示首选项的客户机提供服务URL.(换句话说,它是一个有用的默认值)

应用程序的默认名称(即 Service ID),虚拟主机和非安全端口(来自环境配置)的属性分别是`${spring.application.name}`, `${spring.application.name}` and `${server.port}`.

当应用的类路径有 `spring-cloud-starter-netflix-eureka-client`  使应用注册为一个实例(即注册它自己)和一个客户端(它可以查询注册到本地的其他Services). 实例的行为有 eureka.instance.* 的配置驱动, 但是在默认情况下,但是，如果您确保您的应用程序具有spring.application.name的值(这是Eureka服务ID或VIP的默认值)，那么默认值是没有问题的。

See [EurekaInstanceConfigBean](https://github.com/spring-cloud/spring-cloud-netflix/tree/master/spring-cloud-netflix-eureka-client/src/main/java/org/springframework/cloud/netflix/eureka/EurekaInstanceConfigBean.java) and [EurekaClientConfigBean](https://github.com/spring-cloud/spring-cloud-netflix/tree/master/spring-cloud-netflix-eureka-client/src/main/java/org/springframework/cloud/netflix/eureka/EurekaClientConfigBean.java) for more details on the configurable options.

关闭Eureka Discovery Client, 设置 eureka.client.enabled 为 false,也可以设置spring.cloud.discovery.enabled 为 false.

### Eureka Server 验证

如果其中一个 eureka.client.serviceUrl.defaultZone 的url嵌入凭证(curl 风格所示:  `http://user:password@localhost:8761/eureka`), Http basic 认证自动添加到eureka 客户端,对于更复杂的需求,你可以创建一个@Bean 实例DiscoveryClientOptionalArgs 注入到 ClientFilter中,所有这些都应用于客户机到服务器的调用。

> 由于Eureka的限制，无法支持每服务器基本身份验证凭据，因此仅使用找到的第一个集合。

### 状态页面和健康指标监控

状态页和健康指标在Eureka 实例中分别是 `/info` 和 `/health `这是Spring Boot Actuator应用程序中有用端点的默认位置。如果使用非默认上下文路径或servlet路径(类如 `server.servletPath=/custom`，则需要更改这些，即使对于Actuator应用程序也是如此.

以下示例显示了两个设置的默认值：

**application.yml.** 

```yaml
eureka:
  instance:
    statusPageUrlPath: ${server.servletPath}/info
    healthCheckUrlPath: ${server.servletPath}/health
```