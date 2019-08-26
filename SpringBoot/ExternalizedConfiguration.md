# Spring Boot 特征

## 外部化配置

您可以使用properties文件、YAML文件、环境变量和命令行参数来具体化配置,属性值可以通过使用@Value注释直接注入到bean中, Spring的 Environment 抽象，或者通过@ConfigurationProperties绑定到结构化对象.

Spring Boot使用一种非常特殊的PropertySource顺序，其设计目的是允许合理地覆盖值。属性按以下顺序考虑:

1. 主目录上的Devtools全局设置属性(~/.spring-bootdevtools)。激活devtools时的属性)。
2. @TestPropertySource注释
3. 测试下的properties属性. 用在@SpringBootTest等测试注解
4. 命令行参数
5. 来自SPRING_APPLICATION_JSON(嵌入到环境变量或系统属性中的内联JSON)的属性
6. ServletConfig 初始化参数
7. ServletContext初始化参数
8. 太多了,不想写了(略)

获取属性值,如下所示

```java
import org.springframework.stereotype.*;
import org.springframework.beans.factory.annotation.*;

public class MyBean {
    @Value("${name}")
    private String name;
    // ...
}
```

在程序的类路径,创建`application.properties` 文件,定义name的值.在新环境中,可以在jar包之外覆盖name的值,做一次性测试,例如: 运行指定的命令 java -jar app.jar --name="Spring"

> Tip
>
> 在环境变量上指定SPRING_APPLICATION_JSON 属性,例如在unix中使用:
>
> ```bash
> $ SPRING_APPLICATION_JSON='{"acme":{"name":"test"}}' java -jar myapp.jar
> ```
>
> 您还可以将JSON作为spring.application提供。系统属性中的json，如下例所示:
>
> ```bash
> $ java -Dspring.application.json='{"name":"test"}' -jar myapp.jar	
> ```
>
> 您还可以使用命令行参数提供JSON，如下面的示例所示:
>
> ```bash
> $ java -jar myapp.jar --spring.application.json='{"name":"test"}'
> ```
>
> 您还可以提供JSON作为JNDI变量，如下所示:
>
> java:comp/env/ spring.application.json。



### 配置随机数

例:

```properties
my.secret=${random.value}
my.number=${random.int}
my.bignumber=${random.long}
my.uuid=${random.uuid}
my.number.less.than.ten=${random.int(10)}
my.number.in.range=${random.int[1024,65536]}
```



### 访问命令行属性

命令行参数使用 -- 开始, 例如 --server.port=9000, 命令行参数将作为一个属性添加到环境中,**如前所述，命令行属性始终优先于其他属性源。**

如果你不想使用命令行属性源,关闭方法如下:

```java
SpringApplication.setAddCommandLineProperties(false).
```



### 属性文件

SpringApplication 从application.properties文件加载属性添加它们到环境中. 从如下几个地方进行加载:

1. /config目录下
2. 当前目录中
3. 类路径的 /config 包
4. 类路径的根目录下

列表按优先级排序,在列表中较高位置定义的属性覆盖在较低位置定义的属性.

> 你可以使用  .yml作为.properties的替代

自定义要加载的配置文件的名称使用spring.config.name 属性:

```bash
$ java -jar myproject.jar --spring.config.name=myprojec
```

指定配置文件的位置:

```
$ java -jar myproject.jar --spring.config.location=classpath:/default.properties,classpath:/
override.properties

```

> 警告:
>
> spring.config.name 和 spring.config.location 属性用来指定配置文件的名称和位置,所以它们必须被定义为环境属性,定义成系统环境变量,作为一个系统属性或者命令行参数



### 特殊的配置属性 profile

使用以下命名约定:application-{profile}.properties, 环境中有一个默认的profile ([default]),在没有设置profile的时候使用,换句话说,如果不指定 profile,则使用 application-default.properties.

特定属性和application.properties的加载位置相同, 特定属性的配置文件总是覆盖非特定的属性文件,不管特定于概要文件的文件是在打包的jar内部还是外部。



### 占位符属性

示例:

```properties
app.name=MyApp
app.description=${app.name} is a Spring Boot application
```



### 加密属性

Spring Boot不提供任何内置的对属性值加密的支持，但是它提供了修改Spring环境中包含的值所必需的挂钩点。Environment postprocessor接口允许您在应用程序启动之前操作Environment.

如果您正在寻找一种安全的方式来存储凭证和密码，Spring Cloud Vault项目提供了在HashiCorp Vault中存储外部化配置的支持。

### 使用YAML代替属性

YAML是JSON的一个超集，因此是指定分层配置数据的一种方便的格式。当您的类路径上有SnakeYAML库时，SpringApplication类自动支持YAML作为属性的替代。

> 如果您使用“starter”，SnakeYAML将由spring-boot-starter自动提供

#### 加载YAML

YAML 属性文档:

```yaml
environments:
 dev:
  url: https://dev.example.com
  name: Developer Setup
 prod:
  url: https://another.example.com
  name: My Cool App
```

转为properties如下

```properties
environments.dev.url=https://dev.example.com
environments.dev.name=Developer Setup
environments.prod.url=https://another.example.com
environments.prod.name=My Cool App
```

YAML 的数组

```yaml
my:
servers:
 - dev.example.com
 - another.example.com
```

对应的properties:

```properties
my.servers[0]=dev.example.com
my.servers[1]=another.example.co
```

使用@ConfigurationProperties 注解绑定到对应的实体类上面,如:

```java
@ConfigurationProperties(prefix="my")
public class Config {
 
    private List<String> servers = new ArrayList<String>();
 
    public List<String> getServers() {
        return this.servers;
    }
}
```

#### 在Spring环境中将YAML属性公开

可以使用@Value注释和占位符语法访问YAML属性

#### YAML 文档的多文件

您可以使用spring在一个文件中指定多个特定于概要文件的YAML文档。配置文件键，指示文档何时应用，如下例所示

```yaml
server:
 address: 192.168.1.100
--
spring:
 profiles: development
server:
 address: 127.0.0.1
--
spring:
 profiles: production & eu-central
server:
 address: 192.168.1.120
```

在上面的例子中,如果prifiles 是 development,服务器的地址则是127.0.0.1 如果 production 和 eu-central profiles 是活跃的,则服务器地址是192.168.1.120,如果不活跃,地址则是192.168.1.100.

我们为spring.security.user设置了一个值。只有在“默认”配置文件中可用的密码:

```yaml
server:
  port: 8000
--
spring:
  profiles: default
  security:
    user:
      password: weak
```

然而，在下面的例子中，密码总是被设置，因为它没有附加到任何配置文件中，而且它必须在所有其他配置文件中根据需要显式重置:

```yaml
server:
  port: 8000
spring:
  security:
    user:
      password: weak
```

#### YAML 缺点

无法使用@PropertySource注释加载YAML文件。因此，在需要以这种方式加载值的情况下，需要使用属性文件。

在特定于概要文件的YAML文件中使用多YAML文档语法可能导致意外行为。例如，在一个名为application-dev.yml的文件中考虑以下配置。dev配置文件处于活动状态

```yaml
server:
  port: 8000
--
spring:
  profiles: !test
  security:
    user:
      password: weak
```

在上面的示例中，概要文件否定和概要文件表达式的行为与预期不同。我们建议您不要组合特定于概要文件的YAML文件和多个YAML文档，坚持只使用其中一个.

#### 类型安全的属性配置

对于复杂的pojo获取属性,@Value("${property}") 过于笨重.

```java
@ConfigurationProperties("acme")
public class AcmeProperties {
 private boolean enabled;
 private InetAddress remoteAddress;
 private final Security security = new Security();
```

最后，只考虑标准Java Bean属性，不支持绑定静态属性.

您还需要列出要在@EnableConfigurationProperties注释中注册的属性类，如下面的示例所示:

#### @ConfigurationProperties 验证

当使用了@Validate注释的时候, 在自动注入的时候都会进行验证.例如:

```java
@ConfigurationProperties(prefix="acme")
@Validated
public class AcmeProperties {
 @NotNull
 private InetAddress remoteAddress;
 // ... getters and setters
}
```

#### @ConfigurationProperties 对比 @Value

| Feature | @ConfigurationProperties | @Value |
| ------- | ------------------------ | ------ |
|Relaxed binding |Yes| No|
|Meta-data support| Yes |No|
|SpEL evaluation |No |Yes|

