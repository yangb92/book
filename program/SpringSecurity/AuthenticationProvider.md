# 自定义认证方式

## 自定义认证提供者

```java
@Component
public class DaoAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private AppUserMapper appUserMapper;
    @Autowired
    private AppPermissionMapper permissionMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        AppUser user = appUserMapper.queryByUsername(username);
        if(user == null){
            throw new UsernameNotFoundException("用户未找到");
        }
        if(!passwordEncoder.matches(password,user.getPassword())){
            throw new BadCredentialsException("密码错误");
        }
        List<AppPermission> permissions = permissionMapper.queryByUserid(user.getId());

        return new UsernamePasswordAuthenticationToken(user,password,
                AuthorityUtils.createAuthorityList(permissions.stream().map(item -> item.getCode()).toArray(String[]::new)));
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return (UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication));
    }
}
```

## 在WebSecurityConfig中注入

```java

/**
 * @author Created by yangb on 2020/4/14
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Resource
    private DaoAuthenticationProvider daoAuthenticationProvider;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(daoAuthenticationProvider);
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/admin/**").hasAuthority("ADMIN")
                .anyRequest().authenticated()
                .and()
                .formLogin()
                .loginProcessingUrl("/login")
                .successHandler((request, response, authentication) -> { //登陆陈宫返回json数据
                    response.setContentType("application/json;charset=utf-8");
                    PrintWriter out = response.getWriter();
                    out.write(JSON.toJSONString(ResultVo.makeSuccess("登陆成功")));
                    out.flush();
                    out.close();
                })
                .failureHandler((request, response, exception) -> { //登陆失败返回json数据
                    response.setContentType("application/json;charset=utf-8");
                    PrintWriter out = response.getWriter();
                    ResultVo result = ResultVo.makeFailed(exception.getMessage());
                    out.write(JSON.toJSONString(result));
                    out.flush();
                    out.close();
                })
                .permitAll()
                .and()
                .csrf().disable()
                .exceptionHandling().authenticationEntryPoint((request, response, authException) -> { //访问未授权的资源返回数据
                    response.setContentType("application/json;charset=utf-8");
                    PrintWriter out = response.getWriter();
                    out.write(JSON.toJSONString(ResultVo.makeFailed("请登录后访问")));
                    out.flush();
                    out.close();
                });
    }
}

```

# 验证码校验

前端提交验证码

```java
public class CustomWebAuthenticationDetails extends WebAuthenticationDetails {
    @Getter // 设置getter方法，以便拿到验证码
    private final String validateCode;
    public CustomWebAuthenticationDetails(HttpServletRequest request) {
        super(request);
        // 拿页面传来的验证码
        validateCode = request.getParameter("validateCode");
    }
}
```

配置认证对象
```java
@Component
public class CustomAuthenticationDetailsSource implements AuthenticationDetailsSource<HttpServletRequest, WebAuthenticationDetails> {
    @Override
    public WebAuthenticationDetails buildDetails(HttpServletRequest httpRequest) {
        return new CustomWebAuthenticationDetails(httpRequest);
    }
}

```

spring security 配置

```java
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter { 
    
    // 省略其他
    
    @Autowired
    private AuthenticationDetailsSource authenticationDetailsSource;
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .antMatchers("/get-validate-code").permitAll()
                .anyRequest().authenticated()
              .and()
                .formLogin()
                .loginPage("/user-login").permitAll()
                .loginProcessingUrl("/my-login")
                .authenticationDetailsSource(authenticationDetailsSource);
        http.csrf().disable();
    }
}
```

自定义认证提供者

```java
@Component
public class CustomAuthenticationProvider extends AbstractUserDetailsAuthenticationProvider {
    @Autowired
    private CustomUserDetailsService userDetailsService;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails, UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        // 获取登录提交的用户名和密码
        String inputPassword = (String) authentication.getCredentials();

        // 获取登录提交的验证码
        CustomWebAuthenticationDetails details = (CustomWebAuthenticationDetails) authentication.getDetails();
        String validateCode = details.getValidateCode();

        //校验验证码, 如果错误抛出自定义异常ValidateCodeException

        // 验证用户名
        if (!passwordEncoder.matches(inputPassword, userDetails.getPassword())) {
            throw new BadCredentialsException("密码错误");
        }
    }
    
    @Override
    protected UserDetails retrieveUser(String username, UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken) throws AuthenticationException {
        return userDetailsService.loadUserByUsername(username);
    }
}

```

自定义异常
```java
class ValidateCodeException extends AuthenticationException {
    ValidateCodeException(String message) {
        super(message);
    }
}
```

方法二: 增加过滤器, 判断验证码

```java
@Component
public class SmsCodeFilter extends OncePerRequestFilter {

    @Autowired
    private AuthenticationFailureHandler authenticationFailureHandler;

    private SessionStrategy sessionStrategy = new HttpSessionSessionStrategy();

    @Override
    protected void doFilterInternal(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, 
    	FilterChain filterChain) throws ServletException, IOException {
        if (StringUtils.equalsIgnoreCase("/login/mobile", httpServletRequest.getRequestURI())
                && StringUtils.equalsIgnoreCase(httpServletRequest.getMethod(), "post")) {
            try {
                // 判断验证码的正确性
                validateCode(new ServletWebRequest(httpServletRequest));
            } catch (ValidateCodeException e) {
                authenticationFailureHandler.onAuthenticationFailure(httpServletRequest, httpServletResponse, e);
                return;
            }
        }
        filterChain.doFilter(httpServletRequest, httpServletResponse);
    }

}
```

配置过滤器
```java
@Configuration
public class BrowserSecurityConfig extends WebSecurityConfigurerAdapter {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.
            .addFilterBefore(smsCodeFilter, UsernamePasswordAuthenticationFilter.class) // 添加短信验证码校验过滤器
    }
}

```

