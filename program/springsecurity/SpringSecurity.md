# Spring Security

## 基础概念

* 认证
* 会话
* 授权

### 授权的数据模型

* 主体
* 资源
* 权限
* 角色
* 角色和权限关系
* 主体和角色关系

通常企业开发中将资源和权限表合并为一张表. 数据模型如下:

用户 - 用户角色关系 -> 角色 - 角色权限关系 -> 权限

### RBAC

业界的授权方案

* 基于角色的访问控制 Role-Base Access Control 
* 基于资源的访问控制 Resource-Based Access Control

## 基于Session的认证方式


## Spring Security

WebSecurityConfig 

* 用户信息
* 密码编码器
* 安全拦截机制

### 结构总览

解决用户的 **安全访问控制**, Spring Security 对web资源的保护是靠Filter实现的.

`SpringSecurityFilterChain` 是一个 Servlet 过滤器 实现了 javax.servlet.Filter. 过滤外部请求.

FilterChainProxy代理了多个Filter, 形成Filter链表. AuthenticationManager 负责授权, AccessDecisionManager 负责认证,  


### 自定义UserDetailService

```java
@Service
public class SpringDataUserDetailService implements UserDetailsService
```

### PasswordEncoder

使用`BCryptPasswordEncoder`加密

```java
@Bean
public PasswordEncoder passwordEncoder(){
    return new BCryptPasswordEncoder();
}
```

BCrypt 加密,每次加密结果都不一样,但是校验可以通过,增加了安全性

```java
// 加密原始密码
String hashpw = BCrypt.hashpw("123", BCrypt.gensalt());
System.out.println(hashpw);
//校验密码一致性
boolean checkpw = BCrypt.checkpw("123", "$2a$10$e/Vgw1zKQDdyxd/DvyNSMeeT0TQhaDB9KbUoN8jC2f8MV9lGUobcy");
System.out.println(checkpw);
boolean checkpw1 = BCrypt.checkpw("123", "$2a$10$jIueZHE5S7WJjnZrD//HDugBxKsdLdYfuarmXC.R8S6rJqCv3ifEu");
System.out.println(checkpw1);
```

### 安全拦截

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
    http.authorizeRequests()
        .antMatchers("/r/r1").hasAuthority("p1")
        .antMatchers("/r/r2").hasAuthority("p2")
        .antMatchers("/r").authenticated()
        .anyRequest().permitAll()
        .and()
        .formLogin();
}
```

### 自定义登录页面

增加登录页面
```java
@GetMapping("/login-view")
public String login(){
    return "login";
}
```
自定义登录页面 login.html
```html
<body>
<form action="/login" method="post">
    <table>
        <tr>
            <td>用户名:</td>
            <td><input type="text" name="username"/></td>
        </tr>
        <tr>
            <td>密码:</td>
            <td><input type="password" name="password"/></td>
        </tr>
        <tr><td><input type="submit" value="登录"/></td></tr>
    </table>

</form>

</body>
```
配置http安全设置
```java
@Override
protected void configure(HttpSecurity http) throws Exception {

    http.authorizeRequests()
        ...
        .formLogin()
        .loginPage("/login-view") // 登录页面
        .loginProcessingUrl("/login") //登录路径
        .successForwardUrl("/r") //登录成功跳转路径
        .permitAll()
        .and()
        .csrf().disable(); // 关闭csrf安全验证

```
### 连接数据库认证

添加数据库依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.48</version>
</dependency>
```
配置数据库
```yml
spring:
  datasource:
    username: root
    password: root
    url: jdbc:mysql://localhost:3306/user_db
    driver-class-name: com.mysql.jdbc.Driver
```
实体DTO
```java
@Data
@Table("t_user")
public class UserDto {
    @Id
    private String id;
    private String username;
    private String password;
    private String fullname;
    private String mobile;
}


```
Dao

```java
@Repository
public interface UserDao extends CrudRepository<UserDto,Long> {

    @Query("SELECT * FROM `t_user` where username=:username")
    UserDto findByUsername(@Param("username") String username);
}
```

UserDetailService
```java
@Autowired
private UserDao userDao;

@Override
public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    UserDto userDto = userDao.findByUsername(username);
    if(userDto == null){
        // 如果用户查不到, 返回null, 由provider抛出异常
        return null;
    }
    UserDetails details = User.withUsername(userDto.getUsername()).password(userDto.getPassword()).authorities("p1").build();
    return details;
}
```

### 会话管理

获取用户身份

```java
//获取当前用户信息
private String getUsername(){
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    Object principal = authentication.getPrincipal();
    if(principal == null){
        return "匿名用户";
    }
    if (principal instanceof UserDetails){
        UserDetails userDetails = (UserDetails) principal;
        return userDetails.getUsername();
    }else {
        return principal.toString();
    }
}

```

会话控制

|机制|描述|
|----- |------ |
|always|如果没有session存在就创建一个|
|ifRequired|如果需要就创建一个Session(默认)登录时|
|never|SpringSecurity将不会创建Session,但是如果应用中其他地方创建了Session,那么SpringSecurity将使用它|
|stateless|绝对不会创建和使用|

配置方式
```java
@Override
protected void configure(HttpSecurity http) throws Exception {
    http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED);
```



### 自定义退出

```java
.logout()
    .logoutUrl("/logout") //退出地址
    .logoutSuccessUrl("/index"); //退出页面
```

### Web的授权

使用资源授权, 更灵活.

```java
http.authorizeRequests()
    .antMatchers("/r/r1").hasAuthority("p1")
    .antMatchers("/r/r2").hasAuthority("p2")
    .antMatchers("/r/r3").hasAnyAuthority("p1","p2")
    .antMatchers("/r/r4").access("hasAuthority('p1') and hasAuthority('p2')")
    .antMatchers("/r/**").authenticated()
    .anyRequest().permitAll()
```

### 方法授权

建议基于Controller进行拦截

开启方法拦截

```java
@EnableGlobalMethodSecurity(prePostEnabled = true) //开启方法授权
public class WebSecurityConfig extends WebSecurityConfigurerAdapter{
```

`@PreAuthorize`  在方法上加注解 p1 权限才能访问

```java
@RequestMapping("/r/r1")
@PreAuthorize("hasAuthority('p1')")
public String r1(ModelMap map){
    map.put("name", "权限1页面");
    return "index";
}
```

