# Spring Security

## Security Java配置-Hello World

该配置创建一个Servlet过滤器，称为springSecurityFilterChain，负责所有安全性(保护应用程序url、验证提交的用户名和密码、重定向到登录表单等),下面是Spring Security Java配置的最基本示例:

```java
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.context.annotation.*;
import org.springframework.security.config.annotation.authentication.builders.*;
import org.springframework.security.config.annotation.web.configuration.*;

@EnableWebSecurity
public class WebSecurityConfig implements WebMvcConfigurer {

    @Bean
    public UserDetailsService userDetailsService() throws Exception {
        InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
        manager.createUser(User.withDefaultPasswordEncoder().username("user").password("password").roles("USER").build());
        return manager;
    }
}
```

这个案例的功能摘要:

1. 应用的每个URL都需要授权.
2. 生成一个登陆表单
3. 允许具有用户名和密码的用户使用基于表单的身份验证进行身份验证
4. 允许用户注销登陆
5. CSRF 攻击防御
6. 会话重放攻击防御
7. 安全头集成
8. 集成ServletAPI方法
   * [HttpServletRequest#getRemoteUser()](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html#getRemoteUser()) 
   *  [HttpServletRequest.html#getUserPrincipal()](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html#getUserPrincipal()) 
   *  [HttpServletRequest.html#isUserInRole(java.lang.String)](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html#isUserInRole(java.lang.String)) 
   *  [HttpServletRequest.html#login(java.lang.String, java.lang.String)](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html#login(java.lang.String,%20java.lang.String)) 
   *  [HttpServletRequest.html#logout()](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html#logout())

## HttpSecurity

SpringSecurity 如何知道我们需要对所有用户进行身份验证? SpringSecurity 如何知道我们想要支持基于表单的身份验证?原因是WebSecurityConfigurerAdapter在configure(HttpSecurity http)方法中提供了一个默认配置，如下所示:

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()
            .anyRequest().authenticated()
            .and()
        .formLogin()
            .and()
        .httpBasic();
}
```

以上默认配置:

* 任何请求都需要对用户进行身份验证
* 允许用户使用基于表单的登录进行身份验证
* 允许用户使用HTTP基本身份验证进行身份验证

您会注意到，这个配置与XML名称空间配置非常相似:

```xml
<http>
    <intercept-url pattern="/**" access="authenticated"/>
    <form-login />
    <http-basic />
</http>
```

## Java配置和表单登陆

提供自定义的登陆页

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()
            .anyRequest().authenticated()
            .and()
        .formLogin()
            .loginPage("/login") 
            .permitAll();        
}
```

* 更新后的配置指定登录页面的位置。
* 我们必须授予所有用户访问登陆页面的权限,formLogin().permitall()方法允许为与基于表单的登录相关联的所有url授予所有用户访问权限。

## 授权请求

定制授权需求:

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .authorizeRequests()                                                                
            .antMatchers("/resources/**", "/signup", "/about").permitAll()                  
            .antMatchers("/admin/**").hasRole("ADMIN")                                      
            .antMatchers("/db/**").access("hasRole('ADMIN') and hasRole('DBA')")            
            .anyRequest().authenticated()                                                   
            .and()
        // ...
        .formLogin();
}
```

* authorizerequests()方法有多个子方法，按照声明它们的顺序考虑每个匹配器。
* 我们定义了多个URL地址,任何用户都可以访问,很明确,任何人都能访问 /resources/开头的url. 等于 /singup 或者/about
* 任何以“/admin/”开头的URL都将仅限于具有“ROLE_ADMIN”角色的用户,您将注意到，由于我们调用hasRole方法，所以不需要指定“ROLE_”前缀。
* 任何以“/db/”开头的URL都要求用户同时具有“ROLE_ADMIN”和“ROLE_DBA”。您将注意到，由于我们使用hasRole表达式，所以不需要指定“ROLE_”前缀。
* 任何尚未匹配的URL都只需要对用户进行身份验证

## 注销处理

默认情况下，访问URL /登出将通过以下方式将用户登出:

* 使HTTP会话无效
* 清理任何已配置的memorberme身份验证
* 清理SecurityContextHolder
* 重定向到 /login?logout

不过，与配置登入功能类似，你也有不同的选择，以进一步自订你的登出要求:

```java
protected void configure(HttpSecurity http) throws Exception {
    http
        .logout()                                                                
            .logoutUrl("/my/logout")                                                 
            .logoutSuccessUrl("/my/index")                                           
            .logoutSuccessHandler(logoutSuccessHandler)                              
            .invalidateHttpSession(true)                                             
            .addLogoutHandler(logoutHandler)                                         
            .deleteCookies(cookieNamesToClear)                                       
            .and()
        ...
}
```

* 提供注销的支持。这在使用WebSecurityConfigurerAdapter时自动应用。
* 触发登出的URL(默认为/登出)。如果启用了CSRF保护(默认)，那么请求也必须是POST
* 注销后要重定向到的URL。默认值是/login?logout
* 让我们指定一个自定义LogoutSuccessHandler。如果指定了这一点，logoutSuccessUrl()将被忽略
* 指定是否在注销时使HttpSession无效。默认情况下这是正确的。在幕后配置SecurityContextLogoutHandler。
* 添加一个LogoutHandler。默认情况下，SecurityContextLogoutHandler被添加为最后一个LogoutHandler。
* 许指定要在注销成功时删除的cookie的名称。这是显式添加CookieClearingLogoutHandler的快捷方式。

## 授权

到目前为止，我们只看了最基本的身份验证配置。让我们看一下配置身份验证的一些稍微高级一些的选项。

## 其他认证方式

### UserDetailsService

您可以通过将自定义UserDetailsService公开为bean来定义自定义身份验证。例如，假设SpringDataUserDetailsService实现了UserDetailsService，下面将定制身份验证:

```java
@Bean
public SpringDataUserDetailsService springDataUserDetailsService() {
    return new SpringDataUserDetailsService();
}
```



您还可以通过将PasswordEncoder作为bean公开来定制密码的编码方式。例如，如果您使用bcrypt，您可以添加一个bean定义，如下所示:

```java
@Bean
public BCryptPasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```





## XML 配置

### SpringSecurity Web.xml过滤器配置

```xml
<filter>
<filter-name>springSecurityFilterChain</filter-name>
<filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>

<filter-mapping>
<filter-name>springSecurityFilterChain</filter-name>
<url-pattern>/*</url-pattern>
</filter-mapping>
```

