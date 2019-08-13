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

应用程序的默认名称(它作为Service ID)