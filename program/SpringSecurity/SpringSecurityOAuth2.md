# 分布式系统认证方案

基于Token的认证方式更适合分布式认证.

## 项目搭建
https://github.com/yangb92/SpringAuthorization/tree/spring-cloud-security-oauth2

## 配置授权服务

创建配置类,开启认证服务

```java
@Configuration
@EnableAuthorizationServer
public class AuthorizationServer extends AuthorizationServerConfigurerAdapter {
```

## 配置客户端详细信息

* clentId: (必须) 客户id标识
* secret: 客户端安全码
* scope: 客户端权限
* authorizedGrantTypes: 客户端授权类型,默认为空
* authorities: 此客户端可以使用的授权类型,默认为空

内存方式配置客户端
```java
@Override
public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
    clients.inMemory()
            .withClient("c1")
            .secret(new BCryptPasswordEncoder().encode("secret")) //客户端秘钥
            .resourceIds("res1", "res2") //可访问资源列表
            .authorizedGrantTypes("authorization_code", "password", "client_credentials", "implicit", "refresh_token") //运行授权的类型
            .scopes("all") //允许授权的范围
            .autoApprove(false) // false 跳转到授权页面
            .redirectUris("http://www.baidu.com") //授权回调地址
            .and()
            .withClient ...
}
```


## 配置令牌访问的端点和令牌服务

### 令牌服务

TokenStore: 令牌存储策略

* InMemoryTokenStore: 存储在内存 工作在单服务器
* JdbcTokenStore: 存储在数据库 可以在多个服务器共享
* JwtTokenStore: 不需要后端存储

#### 配置存储方式令牌
存在内存
```java
@Configuration
public class TokenConfig {

    @Bean
    public TokenStore tokenStore() {
        return new InMemoryTokenStore();
    }
}
```

#### 配置令牌管理服务

```java
@Autowired
private TokenStore tokenStore;
@Autowired
private ClientDetailsService clientDetailsService;

// 令牌管理服务
@Bean
public AuthorizationServerTokenServices tokenServices() {
    DefaultTokenServices services = new DefaultTokenServices();
    services.setClientDetailsService(clientDetailsService); // 客户端详情服务
    services.setSupportRefreshToken(true); // 支持令牌刷新
    services.setTokenStore(tokenStore); // 令牌存储策略
    services.setAccessTokenValiditySeconds(7200); // 令牌有效期2小时
    services.setRefreshTokenValiditySeconds(259200); // 刷新令牌默认有效期3天
    return services;
}

```
#### 令牌访问端点配置

AuthorizationServerEndpointsConfigurer 通过设定以下属性决定支持的**授权类型(Grant Types)**

* authenticationManager: 认证管理器,`password`授权类型.用于密码模式需要配置 
* UserDetailService: 用于密码模式需要配置
* authorizationCodeServices: 设置授权码服务的,用于`authorization_code`授权类型
* implicitGrantService: 用于设置隐式授权模式.
* tokenGranter: 当设置了即`TokenGranter`接口实现, 授权将由自己掌控, 这个一般用来做扩展用途.

#### 配置授权端点的URL(Endpoint URLs)
AuthorizationServerEndpointsConfiguration 这个配置对象有一个叫做pathMapping()的方法用来配置端点的URL连接
第一个参数:默认连接, 第二个参数:你需要替换的连接

框架默认的连接如下:

* /oauth/authorize: 授权端点
* /oauth/token: 令牌端点
* /oauth/confirm_access: 用户确认授权端点
* /oauth/error: 授权服务错误信息端点
* /oauth/check_token: 用于资源服务访问的令牌解析端点
* /oauth/token_key: 提供公有密匙的端点, 如果使用JWT令牌的话

WebSecurity配置
```java
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    // 认证管理器
    @Bean
    @Override
    protected AuthenticationManager authenticationManager() throws Exception {
        return super.authenticationManager();
    }

    // 密码编码器
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    // 安全拦截机制
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/r/r1").hasAuthority("p1")
                .antMatchers("/login**").permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin();

    }
}
```
配置令牌访问端点和授权码服务
```java
@Configuration
@EnableAuthorizationServer
public class AuthorizationServer extends AuthorizationServerConfigurerAdapter {

    @Autowired
    private TokenStore tokenStore;
    @Autowired
    private ClientDetailsService clientDetailsService;
    @Autowired
    private AuthorizationCodeServices authorizationCodeServices;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private AuthorizationServerTokenServices tokenServices;

    // 令牌访问端点
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) throws Exception {
        endpoints.authenticationManager(authenticationManager) //认证管理器
                .authorizationCodeServices(authorizationCodeServices) // 授权码服务
                .tokenServices(tokenServices) // 令牌管理服务
                .allowedTokenEndpointRequestMethods(HttpMethod.POST);
    }

    // 配置授权码服务
    @Bean
    public AuthorizationCodeServices authorizationCodeServices() {
        // 设置授权码模式的授权码如何存取,暂时采用内存方式
        return new InMemoryAuthorizationCodeServices();
    }
    
    ...
```

#### 配置令牌端点的安全约束

```java
// 令牌访问安全约束
@Override
public void configure(AuthorizationServerSecurityConfigurer security) throws Exception {
    security
            .tokenKeyAccess("permitAll()")  //oauth/token_key 是公开
            .checkTokenAccess("permitAll()")    //oauth/check_token 公开
            .allowFormAuthenticationForClients(); //表单认证

}
```

## 授权码模式

最为安全

1. 资源拥有者打开客户端,客户端要求资源拥有者给予授权,它将被浏览器重定向到服务器,重定向时会附加客户端身份信息.
```
/uaa/oauth/authorize?client_id=c1&response_type=code&scope=all&redirect_url=http://www.baidu.com/
```
参数:
* client_id: 客户端标识
* response_type: 授权码模式固定位code
* scope:客户端权限
* redirect: 跳转url,授权码申请成功后跳转到此地址,并在后面带上code参数(授权码) 和配置客户端跳转url一致

2. 浏览器重定向授权服务器授权页面,之后用户将同意授权
3. 授权服务器授权码(AuthorizationCode)带到url参数上发送给client(通过redirect_uri)
4. 客户端拿着授权码向授权服务器索要访问access_token
```
/uaa/oauth/token?client_id=c1&client_secret=secret&grant_type=authorization_code&code=5pgxfcD&redirect_uri=http://www.baidu.com/
```

参数:
* cilent_id: 客户端标识
* secret: 客户端密匙
* grant_type: 授权类型
* code: 授权码, 注意:授权码只使用一次就无效了.
* redirect_uri: 和配置客户端跳转url一致

5. 服务器返回授权码

```json
{
    "access_token": "6b94c4c1-1803-484e-b5da-943b96266ff1",
    "token_type": "bearer",
    "refresh_token": "8b4a2631-ef09-4145-9f32-f96b0904e5d8",
    "expires_in": 43199,
    "scope": "all"
}
```

## 简化模式

1. 资源拥有者打开客户端,要求资源拥有者给与授权,它将被浏览器重定向到授权服务器, 重定向时会附加客户端信息.
```url
/uaa/oauth/authorize?client_id=c1&response_type=token&scope=all&redirect_uri=http://www.baidu.com
```
response_type=token 说明是简化模式

2. 浏览器重定向到授权服务器页面,用户同意授权
3. 授权服务器将令牌,以Hash的形式存放在重定向uri的fragment发送给浏览器.
```
https://www.baidu.com/#access_token=6b94c4c1-1803-484e-b5da-943b96266ff1&token_type=bearer&expires_in=42776
```
注: fragment http://example.com#L18 这个`L18`就是fragment的值.

一般来说,简化模式用于没有服务端的第三方单页面应用.

## 密码模式

1. 资源拥有者将用户名,密码发送给客户端.
2. 客户端拿着用户名和密码向授权服务器请求令牌
```
/uaa/oauth/token?client_id=c1&client_secret=secret&grant_type=password&username=lisi&password=123
```
3. 授权服务器将令牌发送给client]

这种模式十分简单,意味着直接将用户敏感信息泄露给了client, 因此这种模式只适用于我们自己的系统

## 客户端模式

1. 客户端向授权服务器发送自己的身份信息,并请求令牌
2. 确认客户端身份无误后,将令牌发送给clien

```
/uaa/oauth/token?client_id=c1&client_secret=secret&grant_type=client_credentials
```

## 资源服务器配置

资源服务配置


测试:

GET http://localhost:53021/order/r1

首先申请Token,将Token放在请求头中,访问资源服务接口
```
Authorization:Bearer 6b94c4c1-1803-484e-b5da-943b96266ff1
```

## JWT 令牌

### 介绍
JWT令牌本身存储了用户信息.不需要进行存储.

优点:
* 基于json
* 自定义内容,易扩展.
* 非对称加密,防篡改,安全
* 资源服务使用JWT不依赖认证服务.

缺点:
令牌过长, 占用空间大.

JWT令牌结构

* Header
* Payload
* Signture

###  UAA 认证端配置

配置: JWT TockenStore

```java
private String SIGN_KEY = "123";

@Bean
public TokenStore tokenStore() {
    // JWT 令牌存储方案
    return new JwtTokenStore(accessTokenConverter());
}

// 令牌转换器
@Bean
public JwtAccessTokenConverter accessTokenConverter() {
    JwtAccessTokenConverter converter = new JwtAccessTokenConverter();
    converter.setSigningKey(SIGN_KEY); // 对称密匙
    return converter;
}
```

配置令牌管理服务
```java
// 令牌管理服务
@Bean
@DependsOn({"tokenStore","accessTokenConverter"})
public AuthorizationServerTokenServices tokenServices(ClientDetailsService clientDetailsService) {
    DefaultTokenServices services = new DefaultTokenServices();
    services.setClientDetailsService(clientDetailsService); // 客户端详情服务
    services.setSupportRefreshToken(true); // 支持令牌刷新
    services.setTokenStore(tokenStore); // 令牌存储策略
    // 令牌增强
    TokenEnhancerChain tokenEnhancerChain = new TokenEnhancerChain();
    tokenEnhancerChain.setTokenEnhancers(Arrays.asList(accessTokenConverter));
    services.setTokenEnhancer(tokenEnhancerChain);
    services.setAccessTokenValiditySeconds(7200); // 令牌有效期2小时
    services.setRefreshTokenValiditySeconds(259200); // 刷新令牌默认有效期3天
    return services;
}
```

### 资源服务配置

TokenConfig
```java
@Configuration
public class TokenConfig {

    private String SIGN_KEY = "123";

    @Bean
    public TokenStore tokenStore() {
        // JWT 令牌存储方案
        return new JwtTokenStore(accessTokenConverter());
    }

    // 令牌转换器
    @Bean
    public JwtAccessTokenConverter accessTokenConverter() {
        JwtAccessTokenConverter converter = new JwtAccessTokenConverter();
        converter.setSigningKey(SIGN_KEY); // 对称密匙
        return converter;
    }
}

```

资源服务配置

```java
@Override
public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
    resources.resourceId(RESOURCE_ID)
//                .tokenServices(tokenServices) //验证令牌的服务
            .tokenStore(tokenStore)
            .stateless(true);
}
```

