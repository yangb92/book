# Spring Boot 特征

## SpringApplication

### 启动特征

当启动失败时， 注册的 `FailureAnalyzers ` 提供专用的错误消息和修复问题的具体操作。

> Spring Boot提供了许多FailureAnalyzer实现，您可以添加自己的实现。

运行jar包启动 debug属性

```bash
$ java -jar myproject-0.0.1-SNAPSHOT.jar --debug
```

### 自定义 Banner

默认加载classpath下的banner.txt(或.gif.jpg.png),指定banner位置： spring.banner.location 属性

禁用Bannner显示,注意off的“”：

```yaml
spring:
 main:
  banner-mode: "off"
```

### 定制SpringApplication

如果你不喜欢SpringApplication的默认属性，你可以创建一个本地实例定制它，下面的示例关闭banner

```java
public static void main(String[] args) {
 SpringApplication app = new SpringApplication(MySpringConfiguration.class);
 app.setBannerMode(Banner.Mode.OFF);
 app.run(args);
}

```

> 传递给SpringApplication的构造函数参数是Spring bean的配置源。在大多数情况下，这些是对@Configuration类的引用，但也可以是对XML配置或应该扫描的包的引用

也可以通过使用应用程序来配置spring应用程序属性文件。

### 链式调用API

如果你需要构建一个ApplicationContext可以使用SpringApplicationBuilder，允许您将多个方法调用链接在一起。如下所示

```java
new SpringApplicationBuilder()
  .sources(Parent.class)
  .child(Application.class)
  .bannerMode(Banner.Mode.OFF)
  .run(args)
```



### 事件监听器

> Note
>
> 有些事件实际上是在创建ApplicationContext之前触发的，因此您不能将侦听器注册为@Bean,您可以使用springapplication . addlistener(…)方法或springapplicationbuilder .listener(…)方法注册它们.如果希望自动注册这些侦听器,不管应用程序是如何创建的,你可以再你的程序中添加META-INF/spring.factories 文件，通过使用org.springframework.context.ApplicationListener作为KEY。例如：
>
> ```properties
> org.springframework.context.ApplicationListener=com.example.project.MyListener
> ```

当应用程序运行时，应用程序事件按以下顺序执行：

1. `ApplicationStartingEvent` 最先执行, 除了注册监听器执行之外。
2. ` ApplicationEnvironmentPreparedEvent `是在上下文环境`Environment`被创建之前
3. `ApplicationPreparedEvent ` 在启动之前，但在Bean加载之后。
4. `ApplicationStartedEvent `在上下文创建之后，但在执行任何程序之前。
5. 在调用任何应用程序和命令行运行程序之后，都会发送一个`ApplicationReadyEvent`。它表明应用程序已经准备好为请求提供服务。
6. 如果启动时出现异常，则发送`ApplicationFailedEvent`.

### Web 环境
`SpringApplication` 尝试创建正确的`ApplicationContext`,用于确定WebApplicationType的算法非常简单
1. 如果 SpringMVC存在，则使用AnnotationConfigServletWebServerApplicationContext。
2. 如果Spring MVC不存在，而Spring WebFlux存在，则使用AnnotationConfigReactiveWebServerApplicationContext 
3. 其他情况下使用 AnnotationConfigApplicationContext

这意味着，如果您在同一个应用程序中使用Spring MVC和Spring WebFlux中的新WebClient，默认情况下将使用Spring MVC。您可以通过调用setWebApplicationType(WebApplicationType)轻松地覆盖它。

还可以通过调用setApplicationContextClass()来完全控制ApplicationContext类型。
>在JUnit测试中使用SpringApplication时，通常需要调用setWebApplicationType(WebApplicationType.NONE)。

### 访问程序的参数
如果你需要访问传递个SpringApplication.run(...) 的参数，可以通过注入org.springframework.boot.ApplicationArguments实现，ApplicationArguments接口提供了参数String[]，和包含非包含的选项，例如：
```java
import org.springframework.boot.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

@Component
public class MyBean {

	@Autowired
	public MyBean(ApplicationArguments args) {
		boolean debug = args.containsOption("debug");
		List<String> files = args.getNonOptionArgs();
		// if run with "--debug logfile.txt" debug=true, files=["logfile.txt"]
	}

}
```
>Spring Boot还向Spring环境注册了一个CommandLinePropertySource。这还允许您通过使用@Value注释注入单个应用程序参数

### 使用ApplicationRunner 或 CommandLineRunner
如果你希望在SpringBoot程序启动时运行一些特定的代码，你可以实现接口ApplicationRunner or CommandLineRunner，这两个接口之提供一个run方法，SpringApplication.run(...)方法执行前调用。

CommandLineRunner接口以简单的字符串数组的形式提供对应用程序参数的访问，而ApplicationRunner使用前面讨论的ApplicationArguments接口。

```java
import org.springframework.boot.*;
import org.springframework.stereotype.*;

@Component
public class MyBean implements CommandLineRunner {

	public void run(String... args) {
		// Do something...
	}

}
```

### 退出程序
每个SpringApplication都会向JVM注册一个关闭钩子，以确保ApplicationContext在退出时正常关闭。可以使用所有标准的Spring生命周期回调（例如DisposableBean接口或@PreDestroy注释）。

### 管理员特性
通过指定spring.application.admin.enabled属性，可以为应用程序启用与管理相关的功能。这会在平台MBeanServer上公开SpringApplicationAdminMXBean。您可以使用此功能远程管理Spring Boot应用程序。 此功能对于任何服务包装器实现也很有用。


