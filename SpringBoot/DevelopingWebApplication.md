# Web应用程序开发

SpringBoot 非常适合开发Web程序开发,大多数web应用程序都使用springboot-starter-web模块快速开发,你也可以选择使用spring-boot-starter-webflux 模块构建响应式Web应用.

## Spring Web MVC Framework

Spring Web MVC 框架(简称 Spring MVC) 是一个富"model view controller" 的web框架, Spring MVC 让你创建特定的@Controller 或 @RestController 的beans 来处理Http请求,控制器中的方法通过使用@RequestMapping注释映射到HTTP.

下面是一个典型的提供JSON数据的@RestController

```java
@RestController
@RequestMapping(value="/users")
public class MyRestController {
 @RequestMapping(value="/\{user}", method=RequestMethod.GET)
 public User getUser(@PathVariable Long user) {
  // ...
 }
 @RequestMapping(value="/\{user}/customers", method=RequestMethod.GET)
 List<Customer> getUserCustomers(@PathVariable Long user) {
  // ...
 }
 @RequestMapping(value="/\{user}", method=RequestMethod.DELETE)
 public User deleteUser(@PathVariable Long user) {
  // ...
 }
}
```

### Spring MVC 自动配置

Spring Boot为Spring MVC提供了自动配置，可以很好地与大多数应用程序配合使用。

自动配置在Spring的默认值之上添加了以下特性:

* 包含ContentNegotiatingViewResolver 和BeanNameViewResolver
* 支持提供静态资源访问, 支持WebJars
* 自动注册 Converter, GenericConverter和Formatter
* 支持HttpMessageConverters 
* 自动注册MessageCodesResolver 
* 支持静态页 index.html
* 支持自定义图标
* 自动使用ConfigurableWebBindingInitializer 

如果你想保留MVC特点并且添加MVC配置(拦截器,格式化,视图解析器和其他功能),你可以使用自己的@Configuration类定义WebMvcConfigurer,但是不包括 @EnableWebMvc 

如果您想完全控制Spring MVC，您可以添加自己的@Configuration，并使用@EnableWebMvc进行注释。

### Http消息转换器

将对象转为JSON或XML,默认使用UTF-8编码.

自定义转换器:

```java
import org.springframework.boot.autoconfigure.http.HttpMessageConverters;
import org.springframework.context.annotation.*;
import org.springframework.http.converter.*;
@Configuration
public class MyConfiguration {
 @Bean
 public HttpMessageConverters customConverters() {
  HttpMessageConverter<?> additional = ...
  HttpMessageConverter<?> another = ...
  return new HttpMessageConverters(additional, another);
 }
}
```

### 自定义JSON序列号和反序列化器

```java
import java.io.*;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.databind.*;
import org.springframework.boot.jackson.*;
@JsonComponent
public class Example {
 public static class Serializer extends JsonSerializer<SomeObject> {
  // ...
 }
 public static class Deserializer extends JsonDeserializer<SomeObject> {
  // ...
 }
}
```

### 静态资源

默认情况下,SpringBoot静态资源目录为ervletContext的根路径下的/static(或 /public 或 /resources 或 /META-INF/resources).

设置静态资源访问url:

```properties
spring.mvc.static-path-pattern=/resources/*
```

设置静态资源位置:

```properties
spring.resources.staticlocations
```

### 欢迎页

它首先在配置的静态内容位置中查找index.html文件,如果没有找到，则查找index模板,它被自动用作应用程序的欢迎页面。

### 自定义网站图标

SpringBoot从已配置的静态资源目录和根目录查找favicon.ico,如果存在,自动使用作为程序图标.

### 路径匹配和内容协议

SpringMVC将HTTP请求映射到方法上, SpringBoot默认禁用后缀,意味着"GET /projects/spring-boot.json" 不会匹配到 @GetMapping("/projects/ spring-boot"

### 模板引擎

除了REST web服务，您还可以使用Spring MVC来提供动态HTML内容.

SpringBoot支持的模板引擎有JSP,以及

• FreeMarker
• Groovy
• Thymeleaf
• Mustache

> TIP 如果可能,尽量避免使用JSP

如果使用模板引擎,自动从src/main/resources/templates位置加载模板,您可以配置模板前缀来搜索类路径上的每个模板目录，如下所示:classpath*:/templates/

### 错误处理

SpringBoot默认提供/error映射处理错误,注册一个全局的错误页面,对于机器客户机，它生成一个JSON响应，其中包含错误的详细信息,HTTP状态和异常消息,对于浏览器客户机，有一个“whitelabel”错误视图，它以HTML格式呈现相同的数据(若要自定义，请添加一个可解析为/error的视图),如果要完全替换默认的错误处理机制,可以实现一个ErrorController并注册,或者添加ErrorAttributes以实现现有机制.

> BasicErrorController可以用作自定义ErrorController的基类。如果您想为新的内容类型添加一个处理程序(默认情况下是专门处理文本/html，并为其他所有内容提供一个回退)，那么这尤其有用。为此，扩展BasicErrorController，添加一个带有@RequestMapping的公共方法，该方法具有produces属性，并创建一个新类型的bean。



### 自定义错误页面

404 页面文件位置

```
src/
 +- main/
     +- java/
     |   + <source code>
     +- resources/
         +- public/
             +- error/
             |   +- 404.html
             +- <other public assets>
```

所有5xx页面,错误页面模板

```
src/
 +- main/
     +- java/
     |   + <source code>
     +- resources/
         +- templates/
             +- error/
             |   +- 5xx.ftl
             +- <other templates>
```

