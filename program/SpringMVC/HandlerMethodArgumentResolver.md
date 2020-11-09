# 自定义参数解析器 HandlerMethodArgumentResolver

定义注解
```java
/**
 * 标记当前用户注解, 由MVC参数解析器注入
 * @author Created by yangb on 2020/4/14
 */
@Target({ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface CurrentUser {
}
```

定义参数解析器UserHandlerMethodArgumentResolver.java
```java

/**
 * 自定义参数解析器
 * @author Created by yangb on 2020/4/14
 */
public class UserHandlerMethodArgumentResolver implements HandlerMethodArgumentResolver {


    @Override
    public boolean supportsParameter(MethodParameter methodParameter) {
        //判断是否需要解析参数, 如果方法参数有CurrentUser注解,需要解析返回true
        return methodParameter.hasParameterAnnotation(CurrentUser.class);  
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        // 解析参数,返回参数对象
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if(principal instanceof AppUser){
            return (AppUser) principal;
        }
        return null;
    }
}
```

在MVC中配置该参数解析器
```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {


    /**
     * 添加参数解析器
     * @param resolvers
     */
    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new UserHandlerMethodArgumentResolver());
    }
}
```

在Controller中使用
```java
    @RequestMapping("/admin")
    public ResultVo admin(@CurrentUser AppUser user) {
        return ResultVo.makeSuccess(user);
    }
```