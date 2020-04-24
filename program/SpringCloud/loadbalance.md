# 负载均衡

## Ribbon

(目前已进入维护模式) 未来替换方案Spring Cloud load-balance

* 服务端负载均衡(集中式): 软件Nginx, LVS,硬件F5等
* 本地负载均衡(进程内):  Ribbon

最新的 `spring-cloud-start-netflix-eureka-client` 已经引入了`ribbon`依赖. 

默认规则为轮询

## 负载规则

* `RoundRobinRule` 轮询
* `RandomRule`随机
* ...

## 替换规则

不能放在@ComponentScan所扫描的当前包以下,创建规则类

```java
@Configuration
public class CustomLoadbalanceRule {
    @Bean
    public IRule customRule(){
        return new RandomRule();
    }
}
```

然后在服务加上注解

```java
@RibbonClient(name="PAYMENT-SERVICE" ,configuration = CustomRule.class )
```

## 自定义规则

略