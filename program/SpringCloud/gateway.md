# 服务网关

## Spring Cloud Gateway

Gateway 是 Zull1.x 的替代.

### 概念

**(1) 功能特性**

基于*异步非阻塞模型*上进行开发, 在 Spring Framework 5, Project Reactor 和 Spring Boot 2.0 进行构建.

特性:

1. 动态路由
2. 对路由指定 Predicate (断言) 和 Filter (过滤器).
3. 集成 Hystrix 断路器
4. 集成 Spring Cloud 服务发现
5. 限流
6. 路径重写

**(2) 与Zuul的区别**

1. Zuul1.x 基于 Servlet2.5 之上的一个阻塞式处理模型, 在高并发不具优势.
2. Gateway 用的是 Spring WebFlux 是 Spring 5.0 引入新的响应式框架.

**(3) 核心概念**

* Route (路由)
* Predicate (断言)
* Filter (过滤)

**(4) 工作流程**

Client -> Spring Cloud Gateway -> Gateway Handler Mapping -> Gateway Web Handler -> Filter -> Proxied Service

### 用法

**(1) pom.xml 配置**

```xml
<!--服务网关-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
<!--服务注册-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

**(2) application.yml 配置**

```yml
server:
  port: 35002

spring:
  application:
    name: gateway-serve
  cloud:
    gateway:
      routes:
        - id: payment-service         # 路由的id, 要求唯一
          uri: http://localhost:8001  # 匹配后提供服务的路由地址
          predicates:
            - Path=/payment/**    # 断言,路径匹配进行路由

        - id: order-service
          uri: http://localhost:8002
          predicates:
            - Path=/order/**

eureka:
  instance:
    hostname: gateway-serve
  client:
    service-url:
      defaultZone: http://localhost:35001/eureka
```

**(3) 编码方式配置路由**

参考[官方文档](https://cloud.spring.io/spring-cloud-static/spring-cloud-gateway/2.2.2.RELEASE/reference/html/#fluent-java-routes-api).

> Tip: 你会发现还是通过yml配置路由简单一点.

**(4) 动态路由配置**

application.yml

```yml
...
spring:
  application:
    name: gateway-serve
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true 				# 开启从注册中心动态创建路由的功能
      routes:
        - id: payment-service
          uri: lb://PAYMENT-SERVICE 	# 注册中心服务地址
          predicates:
            - Path=/payment/**
... 
```

> lb://...  说明:  lb 指 loadbalance

**(5) 断言 Predicate **

[官方文档](https://cloud.spring.io/spring-cloud-static/spring-cloud-gateway/2.2.2.RELEASE/reference/html/#gateway-request-predicates-factories)

断言列表: 

After Route Predicate  在指定日期时间之后请求

```yml
predicates:
  - After=2017-01-20T17:42:47.789-07:00[America/Denver]
```

Before Route Predicate 在指定日期时间之前请求

```yml
predicates:
  - Before=2017-01-20T17:42:47.789-07:00[America/Denver]
```

Between Route Predicate 在指定日期时间之间请求

```yml
predicates:
  - Between=2017-01-20T17:42:47.789-07:00[America/Denver], 2017-01-21T17:42:47.789-07:00[America/Denver]
```

Cookie Route Predicate 匹配具有给定名称且其值与正则表达式匹配的 cookie

```yml
predicates:
  - Cookie=chocolate, ch.p
```

Header Cookie Route Predicate 名称且其值与正则表达式匹配的 head 匹配

```yml
predicates:
  - Header=X-Request-Id, \d+
```

Host Route Predicate 主机名匹配

```yml
predicates:
  - Host=**.somehost.org,**.anotherhost.org
```

Method Route Predicate 方法匹配

```yml
predicates:
  - Method=GET,POST
```

Path Route Predicate 路径匹配

```yml
predicates:
  - Path=/red/{segment},/blue/{segment}
```

Query Route Predicate 参数匹配, 参数名称和参数值得正则表达式

```yml
predicates:
  - Query=red, gree.
```

RemoteAddr Route Predicate IP地址匹配  ip地址/子网掩码

```yml
predicates:
  - RemoteAddr=192.168.1.1/24
```

Weight Route Predicate 配置权重,  组名称和权重值,权重是按组计算的,将20%的流量转发到这个路由

```yml
predicates:
  - Weight=group1, 2
```



**(6) 过滤器 Filter**

[官方文档](https://cloud.spring.io/spring-cloud-static/spring-cloud-gateway/2.2.2.RELEASE/reference/html/#gatewayfilter-factories)

官方自带30个过滤器网关过滤器和10个全局过滤器. 

**自定义过滤器**

```java
@Component
@Slf4j
public class AuthorizationFilter implements GlobalFilter, Ordered {
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        log.info("*** Coming to AuthorizationFilter");
        String uname = exchange.getRequest().getQueryParams().getFirst("uname");
        if (uname == null) {
            log.info("*** 用户名为Null,非法用户!");
            exchange.getResponse()
                .setStatusCode(HttpStatus.NON_AUTHORITATIVE_INFORMATION);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }

    @Override
    public int getOrder() {
        // 过滤器顺序.数字越小,优先级越高
        return 0;
    }
}
```



## Spring Cloud Netflix Zuul  ( 已停用 )

[Zuul 1.x](https://github.com/Netflix/zuul/wiki) 版本已停用,  [Zuul2.0](https://github.com/Netflix/zuul/wiki/Getting-Started-2.0) 还在开发中.

