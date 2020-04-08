# Profiles

Spring概要文件提供了一种方法来隔离应用程序配置的各个部分，并使其仅在某些环境中可用。任何@Component或@Configuration都可以用@Profile标记，

```java
@Configuration
@Profile("production")
public class ProductionConfiguration {
 // ...
}
```

你可以使用spring.profiles.active Environment属性来指定活动的profiles,类如在application.properties中指定:

```properties
spring.profiles.active=dev,hsqldb

```

也可以在命令行指定: --spring.profiles.active=dev,hsqldb

## 添加 Profiles

有时候,我们指定Profiles并不是为了替换掉配置文件,而是需要添加新的配置进来,我们需要:

```yaml
--
my.property: fromyamlfile
--
spring.profiles: prod
spring.profiles.include:
  - proddb
  - prodmq
```

## 通过代码添加Profiles文件

SpringApplication.setAdditionalProfiles(…) 