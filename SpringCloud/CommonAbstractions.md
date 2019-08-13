# Spring Cloud Common Abstractions 概念

如服务发现，负载均衡，断路器等模式提供了一个公共抽象层，所有的Spring 客户端都可以使用这个抽象层，进行独立的实现(例如：服务发现可以用 Eureka 或 Consul)。

## 1.1 @EnableDiscoveryClient 开启服务发现

Spring Cloud Commons 提供了`@EnableDiscoveryClient`注解，这将查找 `META-INF/spring.factories` 中`DiscoveryClient`接口的实现。服务发现的实现类添加到`spring.factories`的org.springframework.cloud.client.discovery.EnableDiscoveryClient的键下面。 例如`DiscoveryClient`的实现类有  [Spring Cloud Netflix Eureka](https://cloud.spring.io/spring-cloud-netflix/), [Spring Cloud Consul Discovery](https://cloud.spring.io/spring-cloud-consul/), and [Spring Cloud Zookeeper Discovery](https://cloud.spring.io/spring-cloud-zookeeper/).

默认情况，`DiscoverClient` 实现将本地SpringBoot 自动注册到远程服务发现服务器, 可以通过在`@EnableDiscoveryClient`中设置`autoRegister = false`来禁用其行为。

> `@EnableDiscoveryClient` 不再是必须的，你也可以在类路径上放置DiscoveryClient，使SpringBoot程序向服务发现服务器注册



## 1.2 健康指标 Health Indicator

Commons 创建了一个Spring Boot 的 HealthIndicator，Discover实现可以通过DiscoverHealthIndicator来参与其中. 禁用混合的HealthIndicator,设置`spring.cloud.discovery.client.composite-indicator.enabled=false` 一个基于DiscoverClient 的HealthIndicator 是自动配置的(`DiscoveryClientHealthIndicator`) 如果要关闭，设置set spring.cloud.discovery.client.health-indicator.enabled=false,关闭属性的描述`DiscoveryClientHealthIndicator` 

设置spring.cloud.discovery.client.health-indicator.include-description=false.否则，它可能会像卷起的HealthIndicator的描述一样冒出来。



## 1.3  订购DiscoveryClient实例

DiscoveryClient 接口继承了 `Ordered` , 这对于使用多个发现服务时非常有用, 它允许你定义返回服务发现的顺序，类似于您可以如何订购Spring应用程序加载的bean。默认所有的DiscoveryClient的顺序都是0，如果你想设置自定义的DiscoveryClient实现的顺序，仅仅只需要重写getOrder()方法，返回您要设置的值。 

... ... 

## 2.1 服务注册

Commons 新提供了一个 `ServiceRegistry` 接口，接口中提供了像 `register(Registration)` 和 `deregister` 这样的方法,它允许你提供自定义注册服务，注册时一个标记接口。

下面是一个正在用的服务注册表：

```java
@Configuration
@EnableDiscoveryClient(autoRegister=false)
public class MyConfiguration {
    private ServiceRegistry registry;

    public MyConfiguration(ServiceRegistry registry) {
        this.registry = registry;
    }

    // called through some external process, such as an event or a custom actuator endpoint
    public void register() {
        Registration registration = constructRegistration();
        this.registry.register(registration);
    }
}
```

每个 ServiceRegistry 实现都有自己的Registry(注册表)实现。

- `ZookeeperRegistration` used with `ZookeeperServiceRegistry`
- `EurekaRegistration` used with `EurekaServiceRegistry`
- `ConsulRegistration` used with `ConsulServiceRegistry`

如果你实现了ServiceRegistry接口，则需要实现ServiceRegistry 的注册表实现。

## 2.2 ServiceRegistry 的自动注册

。。。

## 2.2 服务注册的监控端点

Spring Cloud Common 提供了`/service-registry` 的监控端点，

## 2.3 Spring RestTemplate 做负载均衡

`RestTemplate`可以自动配置使用功能区，创建一个负载均衡的RestTemplate，创建一个RestTemplate @Bean 并且使用@LoadBalance 限定符，如下面的例子所示：

```java
@Configuration
public class MyConfiguration {

    @LoadBalanced
    @Bean
    RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

public class MyClass {
    @Autowired
    private RestTemplate restTemplate;

    public String doOtherStuff() {
        String results = restTemplate.getForObject("http://stores/stores", String.class);
        return results;
    }
}
```

## 2.4 Spring WebClient as a Load Balancer Client

...

## 2.7 Ignore Network Interfaces 忽略网络端口

忽略某些指定的网络接口是有用的，这样它们就可以被排除在服务发现注册之外，可以设置正则表达式列表以忽略所需的网络接口，下面的配置忽略docker0接口和所有以veth开头的接口

**application.yml.** 

```yaml
spring:
  cloud:
    inetutils:
      ignoredInterfaces:
        - docker0
        - veth.*
```

还可以使用正则表达式列表强制只使用指定的网络地址，如下面的示例所示

**bootstrap.yml.** 

```yaml
spring:
  cloud:
    inetutils:
      preferredNetworks:
        - 192.168
        - 10.0
```

您还可以强制只使用站点本地地址，如下面的示例所示:.application.yml

```yaml
spring:
  cloud:
    inetutils:
      useOnlySiteLocalInterfaces: true
```

## 2.8 Http Client 工厂

Spring Cloud Commons 提供了两个Beans，Apache HTTP client(`ApacheHttpClientFactory` )和 OK HTTP client(`OkHttpClientFactory`)。`OkHttpClientFactory` 只有OK HTTP jar 在classpath上存在的时候才会创建。另外，Spring Cloud Common 提供了两个连接管理端：`ApacheHttpClientConnectionManagerFactory` - Apache Http  和 `OkHttpClientConnectionPoolFactory` - Ok Http 

## 2.9 启用功能 

Spring Cloud Commons 提供了一个 /features 监控端点，