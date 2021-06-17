# 服务调用 

## OpenFeign

申明式的Web服务客户端, 只需要创建一个接口并在接口上添加注解即可.

本身已经集成了Ribbon支持负载均衡.

### pom.xml

```xml
<!--服务调用-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

### 启动类配置

```java
@SpringBootApplication
@EnableFeignClients
public class OrderServer {
    ...
```

### 远程接口

```java
/**
 * Created by yangb on 2020/4/23
 * Copyright (c) 2020 杨斌 All rights reserved.
 */
@FeignClient("PAYMENT-SERVICE")
public interface PaymentFeignService {

    @GetMapping("/payment/{id}")
    ResultVo<Payment> getPayment(@PathVariable("id") Long id);

}
```

### 超时控制

Feign 默认只等待1秒钟, 超时报错. 因为使用了ribbon, 所以配置ribbon的连接建立时间

配置超时时间:

```yml
# feign 连接超时配置
ribbon:
    ReadTimeout: 5000 # 连接建立后响应时间
    ConnectTimeout: 5000 # 建立连接所用的时间
```

### 日志功能

日志级别

* NONE: 默认,不显示日志
* BASIC: 记录请求方法,url,响应状态码和执行时间
* HEADERS: 增加请求和响应头
* FULL: 增加请求和响应的正文

#### 配置类

```java
/**
 * Created by yangb on 2020/4/23
 * Copyright (c) 2020 杨斌 All rights reserved.
 */
@Configuration
public class FeignConfig {

    @Bean
    Logger.Level feignLoggerLevel(){
        return Logger.Level.FULL;
    }
}
```

#### application.yml

```yml
logging:
  level:
    com.yangb.business.order.service.PaymentFeignService: debug # feign日志以什么级别监控哪个接口
```

### 断路器

> 启用feign断路器,会导致令牌中继失败 SecurityContextHolder.getContext().getAuthentication() 为null

启用断路器

```yml
# 启用feign熔断器
feign:
  hystrix:
    enabled: true
```

创建FeignClient接口的实现类,用于处理异常情况

```java
@Service
public class PaymentFeignServiceFallbackImpl implements PaymentFeignService {
    @Override
    public ResultVo error() {
        return ResultVo.makeFailed("服务响应失败");
    }
}
```

配置在fallback属性

```java
@FeignClient(value = "PAYMENT-SERVICE",fallback = PaymentFeignServiceFallbackImpl.class)
public interface PaymentFeignService {
    @GetMapping("/payment/timeout")
    ResultVo error();
}
```



## Ribbon + HttpTemplate

