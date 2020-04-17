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