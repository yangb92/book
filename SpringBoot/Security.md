# Security 安全

如果将Spring Security依赖加入, web应用默认保护,Spring Boot依赖于Spring Security的内容协商策略来决定是使用httpBasic还是formLogin。要向web应用程序添加方法级安全性，还可以使用所需的设置添加@EnableGlobalMethodSecurity。

默认得`UserDetailsService` 只有一个用户, 用户名`user`,密码随机打印到INFO级别的日志中,显示如下:

```
Using generated security password: 78fa095d-3f4c-48b1-ad50-e24c31d5cf35
```

自定义用户和密码:

spring.security.user.name 或 spring.security.user.password

DefaultAuthenticationEventPublisher 用于发布默认验证事件. 你也可以提供一个自定义的AuthenticationEventPublisher 

## MVC Security

默认的安全配置在SecurityAutoConfiguration和UserDetailsServiceAutoConfiguration中实现。SecurityAutoConfiguration导入用于web安全的SpringBootWebSecurityConfiguration, UserDetailsServiceAutoConfiguration配置身份验证.也与非web应用程序相关.完全关闭默认的web应用程序安全配置,您可以添加WebSecurityConfigurerAdapter类型的bean(这样做不会禁用UserDetailsService配置或执行器的安全性)

详见[SpringSecurity](../SpringSecurity/Security.md)

## OAuth2.0 客户端

略

## OAuth2.0 资源服务器

略

## OAuth2.0 授权服务器

目前，Spring Security不支持实现OAuth 2.0授权服务器。然而，Spring Security OAuth项目提供了此功能，最终将被Spring Security完全取代。在此之前，您可以使用spring-security-oauth2autoconfigure模块轻松设置OAuth 2.0授权服务器;有关说明，请参阅其文档。

## Actuator Security

为了安全目的,除了/health 和 /info 其他制动器默认是关闭的,management.endpoints.web.exposure。include属性可用于启用执行器

## CSRF防护(Cross Site Request Forgery )

于Spring Boot依赖于Spring Security的默认值，所以CSRF保护在默认情况下是打开的。这意味着，当使用默认安全配置时，执行器端点需要POST (shutdown和loggers端点)、PUT或DELETE将得到403禁止错误!

> 我们建议，只有在创建非浏览器客户端使用的服务时，才完全禁用CSRF保护





