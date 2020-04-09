# Spring

## @DependsOn 注解明确Bean之间依赖关系

```java
@DependsOn({"authorizationCodeServices","authenticationManager","tokenServices"})
```
@Resource 资源要比@Autowride 优先加载 在SpringBoot @Configuration中注入要用@Resource,不然就会出现问题,需要手动指定依赖关系