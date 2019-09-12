# Spring Security OAuth

OAuth 协议请参考 OAuth2.0 章节

## 知识点摘要:

OAuth2.0 授权服务器需实现以下端点:

* `AuthorizationEndpoint`用于为授权请求提供服务。 默认url：/ oauth / authorize

* `TokenEndpoint`用于为访问令牌的请求提供服务。 默认URL：/ oauth / token。

OAuth2.0 资源服务器需实现以下端点:

* OAuth2AuthenticationProcessingFilter用于为给定经过身份验证的访问令牌的请求加载身份验证。

可使用自动配置注解简化配置,也提供了基于XML的配置.

### 授权服务配置

`@EnableAuthorizationServer` 注解自动配置OAuth 2.0 授权服务.  以及需要提供实现`AuthorizationServerConfigurer`  的 @Bean.  AuthorizationServerConfigurer 需要设置的东西有:

* `ClientDetailsServiceConfigurer` 定义客户端信息. 可以自定义也可从仓库来加载客户端信息.
* `AuthorizationServerSecurityConfigurer` 定义令牌端点上的安全性约束
* `AuthorizationServerEndpointsConfigurer` 定义授权和令牌端点以及令牌服务。

XML 中可使用  `<authorization-server/>` 开启自动配置.

#### 客户端详情配置

``ClientDetailsServiceConfigurer` `  需要提供的属性有:

- `clientId`: (required) the client id.
- `secret`: (required for trusted clients) the client secret, if any.
- `scope`: The scope to which the client is limited. If scope is undefined or empty (the default) the client is not limited by scope.
- `authorizedGrantTypes`: Grant types that are authorized for the client to use. Default value is empty.
- `authorities`: Authorities that are granted to the client (regular Spring Security authorities).

可以自己实现`ClientDetailsManager` 定义客户端信息的获取方式.

#### Token 管理

 [`AuthorizationServerTokenServices`](https://docs.spring.io/spring-security/oauth/apidocs/org/springframework/security/oauth2/provider/token/AuthorizationServerTokenServices.html) 定义OAuth2.0令牌所需的操作.

* 创建访问令牌时，必须存储身份验证，以便接受访问令牌的资源稍后可以引用它。
* 访问令牌用于加载其创建的身份验证。

创建  `AuthorizationServerTokenServices` 可以考虑通过[`DefaultTokenServices`](https://docs.spring.io/spring-security/oauth/apidocs/org/springframework/security/oauth2/provider/token/DefaultTokenServices.html) 选择一个令牌管理方式, 默认存放在内存中.

* `InMemoryTokenStore`  默认内存存储

* `JdbcTokenStore` 使用数据库管理, 它将令牌数据存储在关系数据库中。可以在服务器之间共享数据.
* `JwtTokenStore`  他将用户信息直接保存在Token中, 所以不需要后端存储.

#### 配置端点URLs:

AuthorizationServerEndpointsConfigurer 有 pathMapping() 方法,它有两个参数,

* 端点的默认URL路径(框架实现)
* 所需的自定义路径（以“/”开头）

框架提供的URL路径是:

* / oauth / authorize（授权端点）
* /oauth/token（令牌端点）
* / oauth / confirm_access（用户在此授权）
* / oauth / error（用于在授权服务器中呈现错误）
* / oauth / check_token（由资源服务器用于解码访问令牌
* / oauth / token_key（如果使用JWT令牌，则公开用于令牌验证的公钥）



注： 应使用Spring Security保护授权端点/ oauth / authorize（或其映射的替代方案），以便只有经过身份验证的用户才能访问它。 例如，使用标准的Spring Security WebSecurityConfigurer：

```java
 @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests().antMatchers("/login").permitAll().and()
        // default protection for all resources (including /oauth/authorize)
            .authorizeRequests()
                .anyRequest().hasRole("USER")
        // ... more configuration, e.g. for form login
    }
```



### 资源服务器

资源服务器(可以与授权服务器或单独的应用程序相同)提供受OAuth2令牌保护的资源。可以通过@EnableResourceServer 自动配置资源服务器,并且提供一个ResourceServerConfigurer.





原文翻译

----------------------------

## OAuth2.0 提供者

OAuth2.0 提供负责暴露受保护资源的一种机制, 构建一个提供者,OAuth 2.0客户端可独立或代表用户访问其受保护资源的。提供者管理和验证用于访问受保护资源的OAuth 2.0令牌,在适用的情况下，提供者还必须为用户提供一个接口，以确认客户机可以被授予访问受保护资源的权限(即确认页面)。

## OAuth2.0 提供者实现

OAuth 2.0中的提供者角色实际上分为授权服务和资源服务, 虽然它们通常都在一个服务器上, 但是使用Spring Security OAuth你可以将它们分为两个不同的应用, 并且也可使用多个资源服务共享一个授权服务. 对令牌的请求由Spring MVC Controller处理, 访问受保护资源的处理由Spring Security 请求过滤器处理.为了实现OAuth 2.0授权服务器，Spring安全过滤器链中需要以下端点:

* `AuthorizationEndpoint`  用来为认证请求提供服务, 默认URL: /oauth/authorize
* `TokenEndpoint` 用来为获取tokens的提供服务, 默认URL: /oauth/token

OAuth2.0 资源服务器需要实现下面这个过滤器

* `OAuth2AuthenticationProcessingFilter` 用来加载验证请求的Token

对于所有OAuth 2.0提供程序功能，使用特殊的Spring OAuth @Configuration适配器简化了配置,还有一个用于OAuth配置的XML名称空间,模式位于http://www.springframework.org/schema/security/spring-security-oauth2.xsd。 命名空间是http://www.springframework.org/schema/security/oauth2。

## 认证服务器配置

当你配置授权服务器,你必须考虑授权客户端使用什么样的授权类型获取token,例如(例如授权代码、用户凭证、刷新令牌). 服务器配置用于提供客户端详情service和token service的实现,以及启用禁用方面的全局配置.但请注意，每个客户端都可以专门配置权限，以便能够使用某些授权机制和访问授权,也就是说,仅仅因为您的提供程序配置为支持“客户端凭据”授予类型，并不意味着特定客户端有权使用该授权类型。















